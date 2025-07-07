<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Subject List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        html, body { height: 100%; }
        body { display: flex; flex-direction: column; min-height: 100vh; margin: 0; }
        .main-content { flex: 1; }
        a, th, h2, h1, h3, h4, h5, h6 { text-decoration: none !important; border-bottom: none !important; box-shadow: none !important; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/includes/header.jsp" />
<div class="main-content">
    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2>Subject List</h2>
            <button class="btn btn-dark" id="addCourseBtn">Add course</button>
        </div>
        <form method="get" class="row g-3 mb-3">
            <div class="col-md-3">
                <select name="category" class="form-select">
                    <option value="">All Categories</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.id}" ${param.category == cat.id ? 'selected' : ''}>${cat.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3">
                <select name="status" class="form-select">
                    <option value="">All Statuses</option>
                    <option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
                    <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                </select>
            </div>
            <div class="col-md-4">
                <input type="text" name="search" value="${param.search}" class="form-control" placeholder="Search by name" />
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary w-100">Filter</button>
            </div>
        </form>
        <table class="table table-bordered align-middle" id="subjectTable">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Number Lesson</th>
                    <th>Owner</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="subject" items="${subjects}">
                    <tr data-id="${subject.id}">
                        <td>${subject.id}</td>
                        <td><b>${subject.name}</b></td>
                        <td>${subject.categoryName}</td>
                        <td>${subject.lessonCount}</td>
                        <td>${subject.ownerName}</td>
                        <td>
                            <span class="badge ${subject.status eq 'active' ? 'bg-success' : 'bg-danger'}">
                                ${subject.status eq 'active' ? 'Active' : 'Inactive'}
                            </span>
                        </td>
                        <td>
                            <a href="#" class="text-primary edit-btn" data-id="${subject.id}" data-name="${subject.name}" data-category="${subject.categoryName}" data-owner="${subject.ownerName}" data-status="${subject.status}">Edit</a>
                            &nbsp;|&nbsp;
                            <form method="post" action="subject_crud" style="display:inline;" onsubmit="return confirm('Are you sure?')">
                                <input type="hidden" name="id" value="${subject.id}" />
                                <input type="hidden" name="action" value="delete" />
                                <button type="submit" class="text-danger btn btn-link p-0 m-0 align-baseline" style="color:red;">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <!-- Pagination -->
        <nav>
            <ul class="pagination justify-content-center">
                <c:if test="${page > 1}">
                    <li class="page-item"><a class="page-link" href="subject_list?page=${page-1}&search=${param.search}&category=${param.category}&status=${param.status}">Previous</a></li>
                </c:if>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${i==page ? 'active' : ''}"><a class="page-link" href="subject_list?page=${i}&search=${param.search}&category=${param.category}&status=${param.status}">${i}</a></li>
                </c:forEach>
                <c:if test="${page < totalPages}">
                    <li class="page-item"><a class="page-link" href="subject_list?page=${page+1}&search=${param.search}&category=${param.category}&status=${param.status}">Next</a></li>
                </c:if>
            </ul>
        </nav>
    </div>
    <!-- Modal Add/Edit -->
    <div class="modal" id="subjectModal" tabindex="-1" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.3); z-index:2000; align-items:center; justify-content:center;">
        <div style="background:#fff; padding:32px 24px; border-radius:12px; min-width:320px; max-width:90vw; margin:auto; box-shadow:0 4px 32px #888; display:flex; flex-direction:column; gap:16px;">
            <h4 id="modalTitle">Add Subject</h4>
            <form id="subjectForm" method="post" action="subject_crud" onsubmit="return validateSubjectForm();">
                <input type="hidden" name="id" id="subjectId" />
                <div class="mb-2">
                    <label>Name</label>
                    <input type="text" name="name" id="subjectName" class="form-control" required />
                </div>
                <div class="mb-2">
                    <label>Category</label>
                    <select name="categoryId" id="subjectCategory" class="form-select" required>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.id}">${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-2">
                    <label>Owner</label>
                    <input type="text" name="ownerName" id="subjectOwner" class="form-control" required />
                </div>
                <div class="mb-2">
                    <label>Status</label>
                    <select name="status" id="subjectStatus" class="form-select" required>
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
                    </select>
                </div>
                <div id="formError" style="color:red; font-weight:bold; display:none;"></div>
                <div class="d-flex justify-content-end gap-2 mt-3">
                    <button type="button" class="btn btn-secondary" id="closeModalBtn">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save</button>
                </div>
            </form>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
window.onload = function() {
// Show Add modal
const addBtn = document.getElementById('addCourseBtn');
const modal = document.getElementById('subjectModal');
const closeModalBtn = document.getElementById('closeModalBtn');
const form = document.getElementById('subjectForm');
const modalTitle = document.getElementById('modalTitle');
const errorDiv = document.getElementById('formError');
addBtn.onclick = function() {
    modalTitle.textContent = 'Add Subject';
    form.reset();
    document.getElementById('subjectId').value = '';
    errorDiv.style.display = 'none';
    modal.style.display = 'flex';
};
closeModalBtn.onclick = function() {
    modal.style.display = 'none';
};
window.onclick = function(e) {
    if (e.target === modal) modal.style.display = 'none';
};
// Show Edit modal
Array.from(document.getElementsByClassName('edit-btn')).forEach(btn => {
    btn.onclick = function(e) {
        e.preventDefault();
        modalTitle.textContent = 'Edit Subject';
        form.reset();
        errorDiv.style.display = 'none';
        document.getElementById('subjectId').value = btn.getAttribute('data-id');
        document.getElementById('subjectName').value = btn.getAttribute('data-name');
        // Set category by name (simple demo, real app should use id)
        let catSelect = document.getElementById('subjectCategory');
        for (let i = 0; i < catSelect.options.length; i++) {
            if (catSelect.options[i].text === btn.getAttribute('data-category')) catSelect.selectedIndex = i;
        }
        document.getElementById('subjectOwner').value = btn.getAttribute('data-owner');
        document.getElementById('subjectStatus').value = btn.getAttribute('data-status');
        modal.style.display = 'flex';
    };
});
function validateSubjectForm() {
    var name = document.getElementById('subjectName').value.trim();
    var owner = document.getElementById('subjectOwner').value.trim();
    if (name === '' || owner === '') {
        errorDiv.textContent = 'Error: Name and Owner are required!';
        errorDiv.style.display = 'block';
        return false;
    }
    errorDiv.style.display = 'none';
    return true;
}
// Xử lý submit form add/edit bằng AJAX để không reload trang
form.onsubmit = function(e) {
    e.preventDefault();
    if (!validateSubjectForm()) return false;
    const formData = new FormData(form);
    fetch('subject_crud', {
        method: 'POST',
        body: formData
    })
    .then(res => {
        if (res.ok) {
            window.location.reload(); // reload lại để cập nhật bảng
        } else {
            return res.text().then(txt => { throw new Error(txt); });
        }
    })
    .catch(err => {
        errorDiv.textContent = err.message || 'Error saving subject!';
        errorDiv.style.display = 'block';
    });
    return false;
};
// Sửa lại nút Delete: ẩn dòng khỏi bảng và gửi request soft delete bằng fetch, không redirect
Array.from(document.querySelectorAll('form[action="subject_crud"]')).forEach(delForm => {
    delForm.onsubmit = function(e) {
        e.preventDefault();
        if (confirm('Are you sure?')) {
            var row = delForm.closest('tr');
            fetch('subject_crud', {
                method: 'POST',
                body: new URLSearchParams(new FormData(delForm))
            }).then(res => {
                if (res.ok) {
                    if (row) row.parentNode.removeChild(row);
                } else {
                    alert('Delete failed!');
                }
            });
        }
        return false;
    };
});
};
</script>
</body>
</html> 