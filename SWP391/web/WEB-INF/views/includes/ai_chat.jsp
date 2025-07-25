<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- AI Assistant Chat Interface -->
<div id="aiChatContainer" class="ai-chat-container" style="display: none;">
    <div class="ai-chat-panel">
        <!-- Header -->
        <div class="ai-chat-header">
            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <div class="ai-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M12 2L13.09 8.26L20 9L13.09 9.74L12 16L10.91 9.74L4 9L10.91 8.26L12 2Z" fill="#8B5CF6"/>
                        </svg>
                    </div>
                    <span class="ai-title">AI Assistant</span>
                </div>
                <button onclick="toggleAiChat()" class="ai-close-btn">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </button>
            </div>
        </div>

        <!-- Chat Messages -->
        <div class="ai-chat-messages" id="aiChatMessages">
            <div class="ai-message ai-intro">
                <div class="ai-avatar">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M12 2L13.09 8.26L20 9L13.09 9.74L12 16L10.91 9.74L4 9L10.91 8.26L12 2Z" fill="#8B5CF6"/>
                    </svg>
                </div>
                <div class="ai-message-content">
                    <p><strong>Do you have any questions about this course?</strong></p>
                    <p class="ai-disclaimer">Our AI assistant may make mistakes. Verify for accuracy. <a href="#" style="color: #8B5CF6;">Terms Apply</a>.</p>
                </div>
            </div>
        </div>

        <!-- Smart Suggestions -->
        <div class="ai-suggestions-container" id="aiSuggestions" style="display: none;">
            <div class="ai-suggestions-header">
                <span>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right: 6px; vertical-align: text-bottom;">
                        <path d="M9 21H7l-4-4V9a7 7 0 0 1 14 0v8l-4 4h-2"></path>
                        <path d="M9 21v-6a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v6"></path>
                        <path d="M9 7h6"></path>
                        <path d="M9 11h6"></path>
                    </svg>
                    Smart Suggestions
                </span>
                <button onclick="hideSuggestions()" class="ai-suggestions-close">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </button>
            </div>
            <div class="ai-suggestions-list" id="suggestionsList">
                <!-- Suggestions will be populated here -->
            </div>
        </div>
        
        <!-- Input Section -->
        <div class="ai-chat-input-section">
            <div class="ai-status-message" id="aiStatusMessage" style="display: none;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
                AI Assistant is unavailable during practice tests.
            </div>
            
            <div class="ai-chat-input-container">
                <div class="ai-attachment-btn" onclick="toggleSuggestions()">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                        <path d="M21.44 11.05l-9.19 9.19a6 6 0 0 1-8.49-8.49l9.19-9.19a4 4 0 0 1 5.66 5.66l-9.2 9.19a2 2 0 0 1-2.83-2.83l8.49-8.48"/>
                    </svg>
                </div>
                <input type="text" id="aiChatInput" class="ai-chat-input" placeholder="Ask a question" maxlength="500">
                <button id="aiSendBtn" class="ai-send-btn" onclick="sendAiMessage()">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="22" y1="2" x2="11" y2="13"></line>
                        <polygon points="22,2 15,22 11,13 2,9 22,2"></polygon>
                    </svg>
                </button>
            </div>
            
            <div class="ai-chat-footer">
                <button class="ai-feedback-btn" onclick="showFeedbackModal()">Share feedback</button>
                <button class="ai-clear-btn" onclick="clearConversation()">Clear chat</button>
            </div>
        </div>
    </div>
</div>

<!-- AI Chat Toggle Button -->
<button id="aiChatToggle" class="ai-chat-toggle" onclick="toggleAiChat()" title="Ask AI Assistant">
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M12 2L13.09 8.26L20 9L13.09 9.74L12 16L10.91 9.74L4 9L10.91 8.26L12 2Z" fill="white"/>
    </svg>
</button>

<style>
/* AI Chat Styles */
.ai-chat-container {
    position: fixed;
    bottom: 20px;
    right: 20px;
    width: 400px;
    height: 600px;
    background: white;
    border-radius: 12px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
    z-index: 9999;
    display: none;
    flex-direction: column;
    border: 1px solid #e5e7eb;
}

.ai-chat-panel {
    height: 100%;
    display: flex;
    flex-direction: column;
}

.ai-chat-header {
    padding: 16px;
    border-bottom: 1px solid #e5e7eb;
    background: #f9fafb;
    border-radius: 12px 12px 0 0;
}

.ai-icon {
    width: 24px;
    height: 24px;
    margin-right: 8px;
}

.ai-title {
    font-weight: 600;
    color: #374151;
}

.ai-close-btn {
    padding: 4px;
    border: none;
    background: none;
    cursor: pointer;
    color: #6b7280;
    border-radius: 4px;
}

.ai-close-btn:hover {
    background: #e5e7eb;
}

.ai-chat-messages {
    flex: 1;
    padding: 16px;
    overflow-y: auto;
    max-height: 400px;
}

.ai-message {
    display: flex;
    margin-bottom: 16px;
}

.ai-avatar {
    width: 24px;
    height: 24px;
    border-radius: 50%;
    background: #f3f4f6;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
    flex-shrink: 0;
}

.ai-message-content {
    flex: 1;
    color: #374151;
    line-height: 1.5;
}

.ai-disclaimer {
    color: #6b7280;
    font-size: 12px;
    margin-top: 4px;
}

.user-message {
    justify-content: flex-end;
}

.user-message .ai-message-content {
    background: #3b82f6;
    color: white;
    padding: 8px 12px;
    border-radius: 18px;
    max-width: 70%;
}

.ai-loading {
    display: flex;
    align-items: center;
    color: #6b7280;
    font-style: italic;
}

.ai-chat-input-section {
    padding: 16px;
    border-top: 1px solid #e5e7eb;
}

.ai-status-message {
    display: flex;
    align-items: center;
    color: #6b7280;
    font-size: 14px;
    margin-bottom: 12px;
    padding: 8px;
    background: #fef3c7;
    border-radius: 6px;
}

.ai-status-message svg {
    margin-right: 8px;
}

.ai-chat-input-container {
    display: flex;
    align-items: center;
    border: 1px solid #d1d5db;
    border-radius: 24px;
    padding: 8px 12px;
    margin-bottom: 8px;
}

.ai-attachment-btn {
    margin-right: 8px;
    cursor: pointer;
    color: #6b7280;
}

.ai-chat-input {
    flex: 1;
    border: none;
    outline: none;
    font-size: 14px;
    color: #374151;
}

.ai-send-btn {
    background: #8B5CF6;
    border: none;
    border-radius: 50%;
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    color: white;
}

.ai-send-btn:hover {
    background: #7C3AED;
}

.ai-send-btn:disabled {
    background: #d1d5db;
    cursor: not-allowed;
}

.ai-chat-footer {
    text-align: center;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.ai-feedback-btn, .ai-clear-btn {
    color: #6b7280;
    background: none;
    border: none;
    font-size: 12px;
    cursor: pointer;
    text-decoration: underline;
    padding: 4px 8px;
    border-radius: 4px;
    transition: all 0.2s;
}

.ai-feedback-btn:hover, .ai-clear-btn:hover {
    background: #f3f4f6;
    color: #374151;
}

/* Smart Suggestions Styles */
.ai-suggestions-container {
    position: absolute;
    bottom: 100%;
    left: 0;
    right: 0;
    background: white;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    max-height: 200px;
    overflow-y: auto;
    z-index: 1000;
}

.ai-suggestions-header {
    padding: 8px 16px;
    border-bottom: 1px solid #e5e7eb;
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 12px;
    font-weight: 500;
    color: #374151;
}

.ai-suggestions-close {
    background: none;
    border: none;
    font-size: 18px;
    cursor: pointer;
    color: #6b7280;
    padding: 0;
    width: 20px;
    height: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.ai-suggestions-close:hover {
    color: #374151;
}

.ai-suggestions-list {
    padding: 8px 0;
}

.ai-suggestion-item {
    padding: 8px 16px;
    cursor: pointer;
    font-size: 13px;
    color: #374151;
    transition: background-color 0.2s;
}

.ai-suggestion-item:hover {
    background-color: #f3f4f6;
}

.ai-chat-toggle {
    position: fixed;
    bottom: 20px;
    right: 20px;
    width: 56px;
    height: 56px;
    background: #8B5CF6;
    border: none;
    border-radius: 50%;
    box-shadow: 0 4px 16px rgba(139, 92, 246, 0.3);
    cursor: pointer;
    z-index: 10000;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s ease;
}

.ai-chat-toggle:hover {
    background: #7C3AED;
    transform: scale(1.05);
    box-shadow: 0 6px 20px rgba(139, 92, 246, 0.4);
}

.ai-chat-toggle:active {
    transform: scale(0.95);
}

/* Mobile Responsive */
@media (max-width: 640px) {
    .ai-chat-container {
        width: 100vw;
        height: 100vh;
        bottom: 0;
        right: 0;
        border-radius: 0;
    }
    
    .ai-chat-toggle {
        bottom: 80px;
    }
}
</style>

<script>
let isChatOpen = false;

function toggleAiChat() {
    console.log('toggleAiChat called'); // Debug log
    
    const container = document.getElementById('aiChatContainer');
    const toggle = document.getElementById('aiChatToggle');
    
    console.log('Container:', container); // Debug log
    console.log('Toggle:', toggle); // Debug log
    
    if (!container || !toggle) {
        console.error('AI chat elements not found!');
        return;
    }
    
    isChatOpen = !isChatOpen;
    console.log('isChatOpen:', isChatOpen); // Debug log
    
    if (isChatOpen) {
        container.style.display = 'flex';
        toggle.style.display = 'none';
        const input = document.getElementById('aiChatInput');
        if (input) {
            setTimeout(() => input.focus(), 100);
        }
        console.log('AI chat opened'); // Debug log
    } else {
        container.style.display = 'none';
        toggle.style.display = 'flex';
        console.log('AI chat closed'); // Debug log
    }
}

/*
    // 1. Lay user input to chat box
    // 2. Add user message video chat UI
    // 3. Show loading indicator
    // 4. Gui AJAX POST den AiChatServlet voi lessonId + lessonName
    // 5. Xu li response va display AI message
    **/
function sendAiMessage() {
    const input = document.getElementById('aiChatInput');
    const message = input.value.trim();
    
    if (!message) return;
    
    // Add user message
    addMessage(message, 'user');
    input.value = '';
    
    // Add loading indicator
    addLoadingMessage();
    
    // Send to AI (using current lesson context)
    const lessonId = '${currentLesson != null ? currentLesson.id : ""}';
    const lessonName = '${currentLesson != null ? currentLesson.name : ""}';
    
    // Call AI API
    fetch('ai-chat', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'message=' + encodeURIComponent(message) + 
              '&lessonId=' + encodeURIComponent(lessonId) +
              '&lessonName=' + encodeURIComponent(lessonName)
    })
    .then(response => response.json())
    .then(data => {
        removeLoadingMessage();
        addMessage(data.response || 'Sorry, I encountered an error.', 'ai');
    })
    .catch(error => {
        removeLoadingMessage();
        addMessage('Sorry, I encountered an error. Please try again.', 'ai');
        console.error('AI Chat error:', error);
    });
}
/*
    // 1. T?o DOM element cho message
    // 2. Ph�n bi?t user message vs AI message (avatar kh�c nhau)
    // 3. Add v�o chat container
    // 4. Auto scroll to bottom
**/
function addMessage(message, sender) {
    const messagesContainer = document.getElementById('aiChatMessages');
    const messageDiv = document.createElement('div');
    
    if (sender === 'user') {
        messageDiv.className = 'ai-message user-message';
        messageDiv.innerHTML = '<div class="ai-message-content">' + escapeHtml(message) + '</div>';
    } else {
        messageDiv.className = 'ai-message';
        messageDiv.innerHTML = 
            '<div class="ai-avatar">' +
                '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">' +
                    '<path d="M12 2L13.09 8.26L20 9L13.09 9.74L12 16L10.91 9.74L4 9L10.91 8.26L12 2Z" fill="#8B5CF6"/>' +
                '</svg>' +
            '</div>' +
            '<div class="ai-message-content">' + formatAiMessage(message) + '</div>';
    }
    
    messagesContainer.appendChild(messageDiv);
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
}


/*
    // 1. T?o loading indicator v?i AI avatar
    // 2. Show "AI is thinking..." text
    // 3. Add v�o chat container
 * 
 */
function addLoadingMessage() {
    const messagesContainer = document.getElementById('aiChatMessages');
    const loadingDiv = document.createElement('div');
    loadingDiv.id = 'ai-loading-message';
    loadingDiv.className = 'ai-message ai-loading';
    loadingDiv.innerHTML = 
        '<div class="ai-avatar">' +
            '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">' +
                '<path d="M12 2L13.09 8.26L20 9L13.09 9.74L12 16L10.91 9.74L4 9L10.91 8.26L12 2Z" fill="#8B5CF6"/>' +
            '</svg>' +
        '</div>' +
        '<div class="ai-message-content">AI is thinking...</div>';
    
    messagesContainer.appendChild(loadingDiv);
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
}

function removeLoadingMessage() {
    const loadingMsg = document.getElementById('ai-loading-message');
    if (loadingMsg) {
        loadingMsg.remove();
    }
}

function formatAiMessage(message) {
    return escapeHtml(message).replace(/\n/g, '<br>');
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Enhanced AI Chat Functions
function toggleSuggestions() {
    const suggestions = document.getElementById('aiSuggestions');
    if (suggestions.style.display === 'none') {
        loadSuggestions();
        suggestions.style.display = 'block';
    } else {
        suggestions.style.display = 'none';
    }
}

function hideSuggestions() {
    document.getElementById('aiSuggestions').style.display = 'none';
}

function loadSuggestions() {
    const currentLessonName = '${currentLesson != null ? currentLesson.name : ""}';
    const userMessage = document.getElementById('aiChatInput').value;
    
    // Get suggestions based on lesson type
    const lessonId = '${currentLesson != null ? currentLesson.id : ""}';
    
    let suggestions = [
        "Can you summarize this lesson?",
        "What are the key points?",
        "Give me an example",
        "How can I practice this?",
        "What should I focus on?"
    ];
    
    // Reading-specific suggestions
    if (currentLessonName.toLowerCase().includes('reading') || lessonId === '15') {
        suggestions = [
            "Can you summarize this reading?",
            "What are the main concepts?",
            "Explain the key points",
            "How can I apply this knowledge?",
            "What should I remember from this?"
        ];
    }
    
    const suggestionsList = document.getElementById('suggestionsList');
    suggestionsList.innerHTML = '';
    
    suggestions.forEach(suggestion => {
        const div = document.createElement('div');
        div.className = 'ai-suggestion-item';
        div.textContent = suggestion;
        div.onclick = () => {
            document.getElementById('aiChatInput').value = suggestion;
            hideSuggestions();
        };
        suggestionsList.appendChild(div);
    });
}

function clearConversation() {
    if (confirm('Clear all conversation history?')) {
        document.getElementById('aiChatMessages').innerHTML = '';
        // You can add server call to clear conversation memory
        console.log('Conversation cleared');
    }
}

function showFeedbackModal() {
    alert('Feedback feature coming soon!');
}

// Initialize AI Chat functionality
document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing AI Chat...');

    // Check if elements exist
    const container = document.getElementById('aiChatContainer');
    const toggle = document.getElementById('aiChatToggle');
    const input = document.getElementById('aiChatInput');

    console.log('AI Chat elements:', { container, toggle, input });

    // Initialize input functionality
    if (input) {
        input.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendAiMessage();
            }
        });

        // Auto-show suggestions when input is focused
        input.addEventListener('focus', function() {
            if (this.value.trim() === '') {
                loadSuggestions();
                const suggestions = document.getElementById('aiSuggestions');
                if (suggestions) {
                    suggestions.style.display = 'block';
                }
            }
        });
    }

    // Ensure toggle button is visible
    if (toggle) {
        toggle.style.display = 'flex';
        console.log('AI Chat toggle initialized');
    }

    // Ensure container is hidden initially
    if (container) {
        container.style.display = 'none';
        console.log('AI Chat container initialized');
    }
});
</script> 