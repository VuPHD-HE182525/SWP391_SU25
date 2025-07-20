<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/includes/header_subjects.jsp" />

<meta charset="UTF-8">
<title>Course Details</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body {
        font-family: 'Segoe UI', Arial, sans-serif;
        margin: 0;
        background: #f7f7f7;
    }
    .subject-card {
        width: 100%;
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 2px 12px #e0e0e0;
        margin: 8px 0;
        cursor: pointer;
        transition: box-shadow 0.2s;
    }
    .subject-card:hover {
        box-shadow: 0 4px 24px #ccc;
    }
    .subject-card img {
        width: 100%;
        height: 140px;
        object-fit: cover;
        border-radius: 12px 12px 0 0;
        background: #d0eaff;
    }
    .subject-info {
        padding: 18px 16px 16px 16px;
    }
    .subject-title {
        font-size: 1.2em;
        font-weight: bold;
        margin-bottom: 4px;
    }
    .subject-tagline {
        color: #666;
        font-size: 0.98em;
        margin-bottom: 10px;
    }
    .price-info {
        margin-bottom: 10px;
    }
    .list-price {
        color: #888;
        text-decoration: line-through;
        margin-right: 8px;
    }
    .sale-price {
        color: #e74c3c;
        font-weight: bold;
        font-size: 1.1em;
    }
    .register-btn {
        background: #e74c3c;
        color: white;
        border: none;
        padding: 8px 18px;
        border-radius: 4px;
        cursor: pointer;
        float: right;
        font-weight: bold;
        transition: background 0.2s;
    }
    .register-btn:hover {
        background: #c0392b;
    }
    .pagination {
        margin-top: 32px;
        text-align: center;
    }
    .pagination button, .pagination a {
        margin: 0 4px;
        padding: 6px 14px;
        border: none;
        background: #eee;
        border-radius: 4px;
        font-weight: bold;
        cursor: pointer;
        text-decoration: none;
        color: #333;
    }
    .pagination .active {
        background: #e74c3c;
        color: #fff;
    }
</style>

<div class="container-fluid mt-4">
  <div class="row">
    <!-- Sidebar -->
    <div class="col-md-3 mb-4">
      <form method="get" action="course_list" id="searchForm">
          <label>Subject Search</label>
          <div class="input-group mb-3">
              <input type="text" name="search" value="${param.search}" placeholder="Search subjects..." id="searchInput" class="form-control" />
              <button type="button" id="directSearchBtn" class="btn btn-primary">Search</button>
          </div>
          <label style="margin-top: 10px;">Category</label>
          <select name="category" class="form-select mb-3">
              <option value="">All Categories</option>
              <c:forEach var="cat" items="${categories}">
                  <option value="${cat.id}" ${param.category == cat.id ? 'selected' : ''}>${cat.name}</option>
              </c:forEach>
          </select>
          <button type="submit" class="btn btn-danger w-100">Filter</button>
      </form>
      <script>
          let subjectsData = [];
          try {
              subjectsData = JSON.parse('${subjectsJson != null ? subjectsJson : "[]"}');
          } catch (e) {
              console.error("Lỗi khi parse subjectsJson:", e);
              subjectsData = [];
          }
          document.getElementById('directSearchBtn').addEventListener('click', function() {
              const searchTerm = document.getElementById('searchInput').value.trim();
              if (!searchTerm) {
                  alert('Please enter a subject name to search');
                  return;
              }
              const matchedSubject = subjectsData.find(function(subject) {
                  return subject && subject.name.toLowerCase() === searchTerm.toLowerCase();
              });
              if (matchedSubject) {
                  window.location.href = 'course-details?subjectId=' + matchedSubject.id;
              } else {
                  alert('No exact match found for: ' + searchTerm);
              }
          });
          document.getElementById('searchForm').addEventListener('submit', function(e) {
              e.preventDefault();
              this.submit();
          });
      </script>
      <h5 class="mt-4">Subject Categories</h5>
      <ul>
          <c:forEach var="cat" items="${categories}">
              <li>${cat.name}</li>
          </c:forEach>
      </ul>
      <h5 class="mt-4">Featured Subjects</h5>
      <ul>
          <c:forEach var="subj" items="${featuredSubjects}">
              <li>${subj.name}</li>
          </c:forEach>
      </ul>
      <h5 class="mt-4">Contacts</h5>
      <ul>
          <c:forEach var="contact" items="${contacts}">
              <li>${contact.type}: ${contact.value}</li>
          </c:forEach>
      </ul>
    </div>
    <!-- Main Content -->
    <div class="col-md-9">
      <h1 class="text-center mb-4">Subject List</h1>
      <div class="text-end mb-3">
          <button id="showFieldsBtn" class="btn btn-secondary">Click to Show</button>
      </div>
      <!-- Modal for field selection -->
      <div id="fieldsModal" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.3); z-index:1000; align-items:center; justify-content:center;">
          <div style="background:#fff; padding:32px 24px; border-radius:12px; min-width:320px; max-width:90vw; margin:auto; box-shadow:0 4px 32px #888; display:flex; flex-direction:column; gap:16px;">
              <label style="display:flex; align-items:center; gap:12px;"><input type="checkbox" class="field-checkbox" value="image" checked> Course's image</label>
              <label style="display:flex; align-items:center; gap:12px;"><input type="checkbox" class="field-checkbox" value="info" checked> Course's Information</label>
              <label style="display:flex; align-items:center; gap:12px;"><input type="checkbox" class="field-checkbox" value="tag" checked> Course's tag</label>
              <label style="display:flex; align-items:center; gap:12px;"><input type="checkbox" class="field-checkbox" value="prices" checked> Course's prices</label>
              <label style="display:flex; align-items:center; gap:12px;"><input type="checkbox" class="field-checkbox" value="thumbnail" checked> Course's Thumbnail</label>
              <label style="display:flex; align-items:center; gap:12px;"><input type="checkbox" class="field-checkbox" value="title" checked> Course's title</label>
              <button id="applyFieldsBtn" class="btn btn-danger mt-3">Apply Change</button>
          </div>
      </div>
      <script>
      const showFieldsBtn = document.getElementById('showFieldsBtn');
      const fieldsModal = document.getElementById('fieldsModal');
      const applyFieldsBtn = document.getElementById('applyFieldsBtn');
      function saveFieldSelections(selections) {
          localStorage.setItem('subjectFieldSelections', JSON.stringify(selections));
      }
      function loadFieldSelections() {
          const saved = localStorage.getItem('subjectFieldSelections');
          if (saved) {
              const selections = JSON.parse(saved);
              document.querySelectorAll('.field-checkbox').forEach(checkbox => {
                  checkbox.checked = selections.includes(checkbox.value);
              });
              applyFieldSelections(selections);
          }
      }
      function applyFieldSelections(checked) {
          document.querySelectorAll('.subject-card').forEach(card => {
              card.querySelector('img').style.display = checked.includes('image') ? '' : 'none';
              card.querySelector('.subject-info').style.display = checked.includes('info') ? '' : 'none';
              let tag = card.querySelector('.subject-tagline');
              if (tag) tag.style.display = checked.includes('tag') ? '' : 'none';
              let prices = card.querySelector('.price-info');
              if (prices) prices.style.display = checked.includes('prices') ? '' : 'none';
              let thumbnail = card.querySelector('.subject-thumbnail');
              if (thumbnail) thumbnail.style.display = checked.includes('thumbnail') ? '' : 'none';
              let title = card.querySelector('.subject-title');
              if (title) title.style.display = checked.includes('title') ? '' : 'none';
          });
      }
      showFieldsBtn.onclick = function() { fieldsModal.style.display = 'flex'; };
      fieldsModal.onclick = function(e) { if (e.target === fieldsModal) fieldsModal.style.display = 'none'; };
      applyFieldsBtn.onclick = function() {
          const checked = Array.from(document.querySelectorAll('.field-checkbox:checked')).map(cb => cb.value);
          saveFieldSelections(checked);
          applyFieldSelections(checked);
          fieldsModal.style.display = 'none';
      };
      document.addEventListener('DOMContentLoaded', loadFieldSelections);
      </script>
      <div class="row row-cols-1 row-cols-md-2 g-4 subjects-grid">
          <c:forEach var="subject" items="${subjects}">
              <c:choose>
                  <c:when test="${subject != null}">
                      <div class="col">
                          <div class="subject-card" onclick="window.location.href='course-details?subjectId=${subject.id}'">
                              <img src="${subject.thumbnailUrl}" alt="${subject.name}" />
                              <div class="subject-info">
                                  <div class="subject-title">${subject.name}</div>
                                  <div class="subject-tagline">${subject.tagline}</div>
                                  <div class="price-info">
                                      <span class="list-price">
                                          <c:out value='${subject.lowestPackage.originalPrice}' default='--'/>$
                                      </span>
                                      <span class="sale-price">
                                          Sale Price: <c:out value='${subject.lowestPackage.salePrice}' default='--'/>$
                                      </span>
                                  </div>
                                  <form method="Post" action="RegisterSubjectServlet" onClick="event.stopPropagation();">
                                      <input type="hidden" name="id" value="${subject.id}" />
                                      <button type="submit" class="register-btn">Register</button>
                                  </form>
                                  <div style="clear:both"></div>
                              </div>
                          </div>
                      </div>
                  </c:when>
                  <c:otherwise>
                      <div class="col">
                          <div class="subject-card" style="background: #f0f0f0; text-align: center; padding: 20px;">
                              <div style="font-size: 1.2em; color: #666;">No subject available</div>
                          </div>
                      </div>
                  </c:otherwise>
              </c:choose>
          </c:forEach>
      </div>
      <!-- Pagination -->
      <div class="pagination">
          <c:if test="${page > 1}">
              <a href="course_list?page=${page-1}&search=${param.search}&category=${param.category}&pageSize=${pageSize}">Previous</a>
          </c:if>
          <c:forEach begin="1" end="${(totalSubjects/pageSize) + (totalSubjects%pageSize==0?0:1)}" var="i">
              <a href="course_list?page=${i}&search=${param.search}&category=${param.category}&pageSize=${pageSize}" class="${i==page ? 'active' : ''}">${i}</a>
          </c:forEach>
          <c:if test="${page < (totalSubjects/pageSize) + (totalSubjects%pageSize==0?0:1)}">
              <a href="course_list?page=${page+1}&search=${param.search}&category=${param.category}&pageSize=${pageSize}">Next</a>
          </c:if>
          <form method="get" action="course_list" style="display:inline-block; margin-left:10px;">
              <input type="hidden" name="search" value="${param.search}" />
              <input type="hidden" name="category" value="${param.category}" />
              <input type="hidden" name="page" value="1" />
              <input type="number" name="pageSize" min="1" max="100" value="${pageSize}" style="width:60px;" />
              <button type="submit">Items per page</button>
          </form>
      </div>
    </div>
  </div>
</div>
<jsp:include page="/WEB-INF/views/includes/footer_subjects.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
