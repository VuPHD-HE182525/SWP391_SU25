// SIMPLE NAVIGATION FIX - ADD TO LESSON VIEW
// Copy this code and add it to your lesson_view.jsp <script> section

// Clear highlighting on page load
document.addEventListener('DOMContentLoaded', function() {
    // Remove any stuck blue borders
    document.querySelectorAll('.lesson-item').forEach(item => {
        item.classList.remove('current');
        item.style.borderLeft = '';
    });
    
    // Highlight current lesson based on URL
    const currentLessonId = new URLSearchParams(window.location.search).get('lessonId');
    if (currentLessonId) {
        document.querySelectorAll('.lesson-item').forEach(item => {
            if (item.onclick && item.onclick.toString().includes(currentLessonId)) {
                item.classList.add('current');
            }
        });
    }
});

// Fix navigation for Video 2 -> Reading
function goToReadingLesson() {
    showReadingContent();
    setTimeout(() => {
        const readingSection = document.getElementById('readingContentSection');
        if (readingSection) {
            readingSection.scrollIntoView({ behavior: 'smooth' });
        }
    }, 300);
}

// Enhanced clear highlighting
function clearAllHighlighting() {
    document.querySelectorAll('.lesson-item').forEach(item => {
        item.classList.remove('current');
        item.style.borderLeft = '';
    });
}

// MANUAL NAVIGATION BUTTONS (if needed)
// Add these HTML elements where your navigation buttons are:

/*
<!-- For Video 2 (lessonId=2), add this Next button -->
<c:if test="${currentLesson.id == 2}">
    <button onclick="goToReadingLesson()" 
            class="flex items-center px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
        Next: Reading
        <i class="fas fa-chevron-right ml-2"></i>
    </button>
</c:if>
*/ 