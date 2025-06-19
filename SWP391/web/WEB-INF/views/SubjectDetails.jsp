<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Subject Details</title>
    <style>
        .tab-nav {
            display: flex;
            border-bottom: 2px solid #ccc;
            margin-bottom: 20px;
        }
        .tab-nav button {
            background: none;
            border: none;
            font-size: 1.5em;
            margin-right: 30px;
            padding: 10px 0;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            transition: border-color 0.2s;
        }
        .tab-nav button.active {
            border-bottom: 3px solid #6c63ff;
            font-weight: bold;
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }
        .table th, .table td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: left;
        }
        .table th {
            background: #f3f3f3;
        }
    </style>
    <script>
        function showTab(tab) {
            var tabs = document.querySelectorAll('.tab-content');
            var buttons = document.querySelectorAll('.tab-nav button');
            tabs.forEach(function(el) { el.classList.remove('active'); });
            buttons.forEach(function(el) { el.classList.remove('active'); });
            document.getElementById(tab).classList.add('active');
            document.getElementById(tab + '-btn').classList.add('active');
        }
        window.onload = function() {
            showTab('overview');
        };
    </script>
</head>
<body style="min-height: 100vh; display: flex; flex-direction: column;">
    <jsp:include page="includes/header.jsp" />
    <div class="container mx-auto my-8 p-6 bg-white rounded shadow" style="flex: 1 0 auto;">
        <div class="tab-nav mb-6">
            <button id="overview-btn" onclick="showTab('overview')">Overview</button>
            <button id="dimension-btn" onclick="showTab('dimension')">Dimension</button>
            <button id="price-btn" onclick="showTab('price')">Price Package</button>
        </div>
        <div id="overview" class="tab-content">
            <h2 class="text-xl font-bold mb-4">Overview</h2>
            <form action="subjectDetails?id=${subject.id}" method="post" enctype="multipart/form-data">
                <div class="grid grid-cols-2 gap-8">
                    <div>
                        <label>Subject Name</label>
                        //Require HTML
                        <input type="text" name="name" class="w-full border rounded p-2 mb-4" value="${subject.name}" required />
                        <label>Category</label>
                        <select name="category" class="w-full border rounded p-2 mb-4" required>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat}" <c:if test="${cat == subject.category}">selected</c:if>>${cat}</option>
                            </c:forEach>
                        </select>
                        <div class="flex items-center mb-4">
                            <input type="checkbox" name="featured" id="featured" class="mr-2" <c:if test="${subject.featured}">checked</c:if> />
                            <label for="featured">Feature Subject</label>
                        </div>
                        <label>Description</label>
                        <textarea name="description" class="w-full border rounded p-2 mb-4" rows="5" required>${subject.description}</textarea>
                    </div>
                    <div class="flex flex-col items-center">
                        <label>Status</label>
                        <select name="status" class="w-full border rounded p-2 mb-4" required>
                            <option value="Published" <c:if test="${subject.status == 'Published'}">selected</c:if>>Published</option>
                            <option value="Unpublished" <c:if test="${subject.status == 'Unpublished'}">selected</c:if>>Unpublished</option>
                        </select>
                        <label>Image</label>
                        <div style="width:200px;height:200px;border:1px solid #ccc;display:flex;align-items:center;justify-content:center;cursor:pointer;background:#eee;" onclick="document.getElementById('imageInput').click();">
                            <img id="previewImg" src="${subject.thumbnailUrl}" alt="Subject Image" style="max-width:100%;max-height:100%;" />
                        </div>
                        <input type="file" name="thumbnail" id="imageInput" accept="image/*" style="display:none;" onchange="previewImage(event)" />
                    </div>
                </div>
                <div class="mt-6 flex gap-4">
                    <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded">Submit</button>
                    <a href="${pageContext.request.contextPath}/" class="bg-gray-400 text-white px-4 py-2 rounded">Back</a>
                </div>
            </form>
            <script>
                function previewImage(event) {
                    const [file] = event.target.files;
                    if (file) {
                        document.getElementById('previewImg').src = URL.createObjectURL(file);
                    }
                }
            </script>
        </div>
        <div id="dimension" class="tab-content">
            <h2 class="text-xl font-bold mb-4">Dimension</h2>
            <button type="button" class="bg-blue-600 text-white px-4 py-2 rounded mb-4" onclick="showDimensionModal('add')">+ Add new dimension</button>
            <button type="button" class="bg-blue-400 text-white px-4 py-2 rounded mb-4 ml-2" onclick="showColumnModal()">Show/Hide</button>
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Type</th>
                        <th>Dimension</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="d" items="${dimensions}">
                        <tr>
                            <td>${d.id}</td>
                            <td>${d.type}</td>
                            <td>${d.name}</td>
                            <td>
                                <button type="button" class="text-blue-600" 
                                    data-id="${d.id}" 
                                    data-type="${fn:escapeXml(d.type)}" 
                                    data-name="${fn:escapeXml(d.name)}" 
                                    onclick="showDimensionModal('edit', this.dataset.id, this.dataset.type, this.dataset.name)">Edit</button>
                                <form action="subjectDetails?id=${subject.id}" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="deleteDimension" />
                                    <input type="hidden" name="dimensionId" value="${d.id}" />
                                    <button type="submit" class="text-red-600 ml-2" onclick="return confirm('Delete this dimension?')">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <!-- Modal for Add/Edit Dimension -->
            <div id="dimensionModal" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;background:rgba(0,0,0,0.3);align-items:center;justify-content:center;z-index:1000;">
                <div style="background:#fff;padding:2rem;border-radius:8px;min-width:300px;max-width:90vw;">
                    <h3 id="dimensionModalTitle" class="text-lg font-bold mb-2"></h3>
                    <form id="dimensionForm" action="subjectDetails?id=${subject.id}" method="post">
                        <input type="hidden" name="action" id="dimensionAction" value="" />
                        <input type="hidden" name="dimensionId" id="dimensionId" value="" />
                        <label>Type</label>
                        <input type="text" name="type" id="dimensionType" class="w-full border rounded p-2 mb-2" required />
                        <label>Dimension</label>
                        <input type="text" name="name" id="dimensionName" class="w-full border rounded p-2 mb-2" required />
                        <div class="flex gap-2 mt-2">
                            <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded">Save</button>
                            <button type="button" class="bg-gray-400 text-white px-4 py-2 rounded" onclick="hideDimensionModal()">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
            <!-- Modal for Show/Hide Columns -->
            <div id="columnModal" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;background:rgba(0,0,0,0.3);align-items:center;justify-content:center;z-index:1000;">
                <div style="background:#fff;padding:2rem;border-radius:8px;min-width:300px;max-width:90vw;">
                    <h3 class="text-lg font-bold mb-2">Choose what you want to show/hide</h3>
                    <form id="columnForm">
                        <label><input type="checkbox" class="col-toggle" data-col="0" checked> ID</label>
                        <label class="ml-4"><input type="checkbox" class="col-toggle" data-col="1" checked> Type</label>
                        <label class="ml-4"><input type="checkbox" class="col-toggle" data-col="2" checked> Dimension</label>
                        <label class="ml-4"><input type="checkbox" class="col-toggle" data-col="3" checked> Action</label>
                    </form>
                    <button type="button" class="bg-gray-400 text-white px-4 py-2 rounded mt-4" onclick="hideColumnModal()">Close</button>
                </div>
            </div>
            <script>
                function showDimensionModal(mode, id, type, name) {
                    document.getElementById('dimensionModal').style.display = 'flex';
                    if (mode === 'add') {
                        document.getElementById('dimensionModalTitle').innerText = 'Add Dimension';
                        document.getElementById('dimensionAction').value = 'addDimension';
                        document.getElementById('dimensionId').value = '';
                        document.getElementById('dimensionType').value = '';
                        document.getElementById('dimensionName').value = '';
                    } else {
                        document.getElementById('dimensionModalTitle').innerText = 'Edit Dimension';
                        document.getElementById('dimensionAction').value = 'editDimension';
                        document.getElementById('dimensionId').value = id;
                        document.getElementById('dimensionType').value = type;
                        document.getElementById('dimensionName').value = name;
                    }
                }
                function hideDimensionModal() {
                    document.getElementById('dimensionModal').style.display = 'none';
                }
                function showColumnModal() {
                    document.getElementById('columnModal').style.display = 'flex';
                }
                function hideColumnModal() {
                    document.getElementById('columnModal').style.display = 'none';
                }
                document.addEventListener('DOMContentLoaded', function() {
                    document.querySelectorAll('.col-toggle').forEach(function(checkbox) {
                        checkbox.addEventListener('change', function() {
                            var colIdx = parseInt(this.dataset.col);
                            var show = this.checked;
                            var table = document.querySelector('#dimension .table');
                            if (!table) return;
                            // Toggle header
                            var th = table.querySelectorAll('th')[colIdx];
                            if (th) th.style.display = show ? '' : 'none';
                            // Toggle all rows
                            table.querySelectorAll('tr').forEach(function(row) {
                                var td = row.querySelectorAll('td, th')[colIdx];
                                if (td) td.style.display = show ? '' : 'none';
                            });
                        });
                    });
                });
            </script>
        </div>
        <div id="price" class="tab-content">
            <h2 class="text-xl font-bold mb-4">Price Package</h2>
            <button type="button" class="bg-blue-600 text-white px-4 py-2 rounded mb-4" onclick="showPriceModal('add')">+ Add new Package</button>
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Package</th>
                        <th>Duration</th>
                        <th>List Price</th>
                        <th>Sale Price</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${pricePackages}">
                        <tr>
                            <td>${p.id}</td>
                            <td>${p.name}</td>
                            <td>${p.duration}</td>
                            <td>${p.listPrice}</td>
                            <td>${p.salePrice}</td>
                            <td>${p.status}</td>
                            <td>
                                <button type="button" class="text-blue-600" 
                                    data-id="${p.id}" 
                                    data-name="${fn:escapeXml(p.name)}" 
                                    data-duration="${p.duration}" 
                                    data-listprice="${p.listPrice}" 
                                    data-saleprice="${p.salePrice}" 
                                    data-status="${fn:escapeXml(p.status)}" 
                                    onclick="showPriceModal('edit', this.dataset.id, this.dataset.name, this.dataset.duration, this.dataset.listprice, this.dataset.saleprice, this.dataset.status)">Edit</button>
                                <form action="subjectDetails?id=${subject.id}" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="deletePrice" />
                                    <input type="hidden" name="priceId" value="${p.id}" />
                                    <button type="submit" class="text-red-600 ml-2" onclick="return confirm('Delete this price package?')">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <!-- Modal for Add/Edit Price Package -->
            <div id="priceModal" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;background:rgba(0,0,0,0.3);align-items:center;justify-content:center;z-index:1000;">
                <div style="background:#fff;padding:2rem;border-radius:8px;min-width:300px;max-width:90vw;">
                    <h3 id="priceModalTitle" class="text-lg font-bold mb-2"></h3>
                    <form id="priceForm" action="subjectDetails?id=${subject.id}" method="post">
                        <input type="hidden" name="action" id="priceAction" value="" />
                        <input type="hidden" name="priceId" id="priceId" value="" />
                        <label>Package</label>
                        <input type="text" name="name" id="priceName" class="w-full border rounded p-2 mb-2" required />
                        <label>Duration</label>
                        <input type="number" name="duration" id="priceDuration" class="w-full border rounded p-2 mb-2" required />
                        <label>List Price</label>
                        <input type="number" name="listPrice" id="priceListPrice" class="w-full border rounded p-2 mb-2" required />
                        <label>Sale Price</label>
                        <input type="number" name="salePrice" id="priceSalePrice" class="w-full border rounded p-2 mb-2" required />
                        <label>Status</label>
                        <select name="status" id="priceStatus" class="w-full border rounded p-2 mb-2" required>
                            <option value="Published">Published</option>
                            <option value="Unpublish">Unpublish</option>
                        </select>
                        <div class="flex gap-2 mt-2">
                            <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded">Save</button>
                            <button type="button" class="bg-gray-400 text-white px-4 py-2 rounded" onclick="hidePriceModal()">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
            <script>
                function showPriceModal(mode, id, name, duration, listPrice, salePrice, status) {
                    document.getElementById('priceModal').style.display = 'flex';
                    if (mode === 'add') {
                        document.getElementById('priceModalTitle').innerText = 'Add Price Package';
                        document.getElementById('priceAction').value = 'addPrice';
                        document.getElementById('priceId').value = '';
                        document.getElementById('priceName').value = '';
                        document.getElementById('priceDuration').value = '';
                        document.getElementById('priceListPrice').value = '';
                        document.getElementById('priceSalePrice').value = '';
                        document.getElementById('priceStatus').value = 'Published';
                    } else {
                        document.getElementById('priceModalTitle').innerText = 'Edit Price Package';
                        document.getElementById('priceAction').value = 'editPrice';
                        document.getElementById('priceId').value = id;
                        document.getElementById('priceName').value = name;
                        document.getElementById('priceDuration').value = duration;
                        document.getElementById('priceListPrice').value = listPrice;
                        document.getElementById('priceSalePrice').value = salePrice;
                        document.getElementById('priceStatus').value = status;
                    }
                }
                function hidePriceModal() {
                    document.getElementById('priceModal').style.display = 'none';
                }
            </script>
        </div>
    </div>
    <jsp:include page="includes/footer.jsp" />
</body>
</html> 