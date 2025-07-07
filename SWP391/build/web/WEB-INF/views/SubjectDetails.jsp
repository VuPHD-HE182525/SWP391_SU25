<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Subject Details</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
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
</head>
<body style="min-height: 100vh; display: flex; flex-direction: column;">
    <jsp:include page="includes/header.jsp" />
    <div class="container my-5" style="flex: 1 0 auto;">
        <!-- Bootstrap Nav Tabs -->
        <ul class="nav nav-tabs mb-4" id="subjectTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="overview-tab" data-bs-toggle="tab" data-bs-target="#overview" type="button" role="tab" aria-controls="overview" aria-selected="true">Overview</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="dimension-tab" data-bs-toggle="tab" data-bs-target="#dimension" type="button" role="tab" aria-controls="dimension" aria-selected="false">Dimension</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="price-tab" data-bs-toggle="tab" data-bs-target="#price" type="button" role="tab" aria-controls="price" aria-selected="false">Price Package</button>
            </li>
        </ul>
        <div class="tab-content" id="subjectTabContent">
            <!-- Overview Tab -->
            <div class="tab-pane fade show active" id="overview" role="tabpanel" aria-labelledby="overview-tab">
                <h2 class="mb-4">Overview</h2>
                <form action="${pageContext.request.contextPath}/subject-details?id=${subject.id}" method="post" enctype="multipart/form-data">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Subject Name</label>
                                <input type="text" name="name" class="form-control" value="${subject.name}" required />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Category</label>
                                <select name="category" class="form-select" required>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.id}" <c:if test="${cat.id == subject.categoryId}">selected</c:if>>${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" name="featured" id="featured" <c:if test="${subject.featured}">checked</c:if> />
                                <label class="form-check-label" for="featured">Feature Subject</label>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <textarea name="description" class="form-control" rows="5" required>${subject.description}</textarea>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Status</label>
                                <select name="status" class="form-select" required>
                                    <option value="Published" <c:if test="${subject.status == 'Published'}">selected</c:if>>Published</option>
                                    <option value="Unpublished" <c:if test="${subject.status == 'Unpublished'}">selected</c:if>>Unpublished</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Image</label>
                                <div class="border rounded d-flex align-items-center justify-content-center bg-light" style="width:200px;height:200px;cursor:pointer;" onclick="document.getElementById('imageInput').click();">
                                    <img id="previewImg" src="${subject.thumbnailUrl}" alt="Subject Image" style="max-width:100%;max-height:100%;" />
                                </div>
                                <input type="file" name="thumbnail" id="imageInput" accept="image/*" style="display:none;" onchange="previewImage(event)" />
                            </div>
                        </div>
                    </div>
                    <div class="mt-4 d-flex gap-3">
                        <button type="submit" class="btn btn-primary">Submit</button>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Back</a>
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
            <!-- Dimension Tab -->
            <div class="tab-pane fade" id="dimension" role="tabpanel" aria-labelledby="dimension-tab">
                <h2 class="mb-4">Dimension</h2>
                <div class="d-flex align-items-center mb-3 gap-3">
                    <button type="button" class="btn btn-primary" onclick="showDimensionModal('add')">+ Add new dimension</button>
                    <button type="button" class="btn btn-info text-white" onclick="showColumnModal()">Show/Hide</button>
                    <div class="ms-auto d-flex align-items-center gap-2">
                        <label for="numRowsInput" class="mb-0">Number of row:</label>
                        <input type="number" id="numRowsInput" min="1" value="10" style="width:80px;" class="form-control form-control-sm" />
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table table-bordered align-middle" id="dimensionTable">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Type</th>
                                <th>Dimension</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="d" items="${dimensions}" varStatus="loop">
                                <tr class="dimension-row">
                                    <td>${d.id}</td>
                                    <td>${d.type}</td>
                                    <td>${d.name}</td>
                                    <td>
                                        <button type="button" class="btn btn-link p-0 text-primary" 
                                            data-id="${d.id}" 
                                            data-type="${fn:escapeXml(d.type)}" 
                                            data-name="${fn:escapeXml(d.name)}" 
                                            onclick="showDimensionModal('edit', this.dataset.id, this.dataset.type, this.dataset.name)">Edit</button>
                                        <form action="${pageContext.request.contextPath}/subject-details?id=${subject.id}" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="deleteDimension" />
                                            <input type="hidden" name="dimensionId" value="${d.id}" />
                                            <button type="submit" class="btn btn-link p-0 text-danger ms-2" onclick="return confirm('Delete this dimension?')">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <!-- Modal for Add/Edit Dimension -->
                <div class="modal fade" id="dimensionModal" tabindex="-1" aria-labelledby="dimensionModalTitle" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="dimensionModalTitle"></h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <form id="dimensionForm" action="${pageContext.request.contextPath}/subject-details?id=${subject.id}" method="post">
                                <div class="modal-body">
                                    <input type="hidden" name="action" id="dimensionAction" value="" />
                                    <input type="hidden" name="dimensionId" id="dimensionId" value="" />
                                    <div class="mb-3">
                                        <label class="form-label">Type</label>
                                        <input type="text" name="type" id="dimensionType" class="form-control" required />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Dimension</label>
                                        <input type="text" name="name" id="dimensionName" class="form-control" required />
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-primary">Save</button>
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <!-- Modal for Show/Hide Columns -->
                <div class="modal fade" id="columnModal" tabindex="-1" aria-labelledby="columnModalTitle" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="columnModalTitle">Choose what you want to show/hide</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <form id="columnForm">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input col-toggle" type="checkbox" data-col="0" checked id="col0">
                                        <label class="form-check-label" for="col0">ID</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input col-toggle" type="checkbox" data-col="1" checked id="col1">
                                        <label class="form-check-label" for="col1">Type</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input col-toggle" type="checkbox" data-col="2" checked id="col2">
                                        <label class="form-check-label" for="col2">Dimension</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input col-toggle" type="checkbox" data-col="3" checked id="col3">
                                        <label class="form-check-label" for="col3">Action</label>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>
                <script>
                    function showDimensionModal(mode, id, type, name) {
                        var modal = new bootstrap.Modal(document.getElementById('dimensionModal'));
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
                        modal.show();
                    }
                    function showColumnModal() {
                        var modal = new bootstrap.Modal(document.getElementById('columnModal'));
                        modal.show();
                    }
                    document.addEventListener('DOMContentLoaded', function() {
                        // Number of row logic: set max = số dòng thực tế
                        var allRows = Array.from(document.querySelectorAll('#dimensionTable tbody tr'));
                        var numRowsInput = document.getElementById('numRowsInput');
                        numRowsInput.max = allRows.length;
                        if (parseInt(numRowsInput.value) > allRows.length) numRowsInput.value = allRows.length;
                        function updateRowDisplay() {
                            var num = Math.max(1, Math.min(parseInt(numRowsInput.value) || 1, allRows.length));
                            numRowsInput.value = num; // luôn giữ value hợp lệ
                            allRows.forEach(function(row, idx) {
                                row.style.display = (idx < num) ? '' : 'none';
                            });
                        }
                        numRowsInput.addEventListener('input', updateRowDisplay);
                        updateRowDisplay();
                        // Show/hide columns logic: luôn giữ lại 1 ô được tick, enable lại khi tick thêm. Không bao giờ cho phép bỏ tick hết.
                        function updateColToggleState() {
                            var checkboxes = Array.from(document.querySelectorAll('.col-toggle'));
                            var checked = checkboxes.filter(cb => cb.checked);
                            if (checked.length === 1) {
                                checkboxes.forEach(cb => {
                                    cb.disabled = cb.checked ? true : false;
                                });
                            } else {
                                checkboxes.forEach(cb => {
                                    cb.disabled = false;
                                });
                            }
                        }
                        document.querySelectorAll('.col-toggle').forEach(function(checkbox) {
                            checkbox.addEventListener('change', function() {
                                var checkboxes = Array.from(document.querySelectorAll('.col-toggle'));
                                var checked = checkboxes.filter(cb => cb.checked);
                                // Nếu user cố bỏ tick hết, revert lại
                                if (checked.length === 0) {
                                    this.checked = true;
                                    updateColToggleState();
                                    return;
                                }
                                // Nếu tick lại ô khác, enable lại tất cả các ô
                                if (checked.length > 1) {
                                    checkboxes.forEach(cb => cb.disabled = false);
                                }
                                var col = this.getAttribute('data-col');
                                var table = document.querySelector('#dimensionTable');
                                if (table) {
                                    // Toggle th
                                    var th = table.querySelectorAll('th')[col];
                                    if (th) th.style.display = this.checked ? '' : 'none';
                                    // Toggle td
                                    table.querySelectorAll('tbody tr').forEach(function(row) {
                                        var td = row.querySelectorAll('td')[col];
                                        if (td) td.style.display = checkbox.checked ? '' : 'none';
                                    });
                                }
                                updateColToggleState();
                            });
                        });
                        updateColToggleState();
                    });
                </script>
            </div>
            <!-- Price Package Tab -->
            <div class="tab-pane fade" id="price" role="tabpanel" aria-labelledby="price-tab">
                <h2 class="mb-4">Price Package</h2>
                <button type="button" class="btn btn-primary mb-3" onclick="showPriceModal('add')">+ Add new Package</button>
                <div class="table-responsive">
                    <table class="table table-bordered align-middle">
                        <thead class="table-light">
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
                                        <button type="button" class="btn btn-link p-0 text-primary"
                                            data-id="${p.id}"
                                            data-name="${fn:escapeXml(p.name)}"
                                            data-duration="${p.duration}"
                                            data-listprice="${p.listPrice}"
                                            data-saleprice="${p.salePrice}"
                                            data-status="${fn:escapeXml(p.status)}"
                                            onclick="showPriceModal('edit', this.dataset.id, this.dataset.name, this.dataset.duration, this.dataset.listprice, this.dataset.saleprice, this.dataset.status)">Edit</button>
                                        <form action="${pageContext.request.contextPath}/subject-details?id=${subject.id}" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="deletePrice" />
                                            <input type="hidden" name="priceId" value="${p.id}" />
                                            <button type="submit" class="btn btn-link p-0 text-danger ms-2" onclick="return confirm('Delete this price package?')">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <!-- Modal for Add/Edit Price Package -->
                <div class="modal fade" id="priceModal" tabindex="-1" aria-labelledby="priceModalTitle" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="priceModalTitle"></h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <form id="priceForm" action="${pageContext.request.contextPath}/subject-details?id=${subject.id}" method="post">
                                <div class="modal-body">
                                    <input type="hidden" name="action" id="priceAction" value="" />
                                    <input type="hidden" name="priceId" id="priceId" value="" />
                                    <div class="mb-3">
                                        <label class="form-label">Package</label>
                                        <input type="text" name="name" id="priceName" class="form-control" required />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Duration</label>
                                        <input type="number" name="duration" id="priceDuration" class="form-control" required />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">List Price</label>
                                        <input type="number" name="listPrice" id="priceListPrice" class="form-control" required />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Sale Price</label>
                                        <input type="number" name="salePrice" id="priceSalePrice" class="form-control" required />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Status</label>
                                        <select name="status" id="priceStatus" class="form-select" required>
                                            <option value="Published">Published</option>
                                            <option value="Unpublish">Unpublish</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-primary">Save</button>
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <script>
                    function showPriceModal(mode, id, name, duration, listPrice, salePrice, status) {
                        var modal = new bootstrap.Modal(document.getElementById('priceModal'));
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
                        modal.show();
                    }
                </script>
            </div>
        </div>
    </div>
    <jsp:include page="includes/footer.jsp" />
    <!-- Đảm bảo import đúng Bootstrap JS bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 