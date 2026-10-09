/**
 * CampusHire - College Placement and Internship Management System
 * Client-Side JavaScript Helpers
 */

document.addEventListener('DOMContentLoaded', function () {
    // 1. Role Tabs in Login Page
    const tabs = document.querySelectorAll('.auth-tab');
    const roleInput = document.getElementById('selectedRole');
    
    if (tabs.length > 0 && roleInput) {
        tabs.forEach(tab => {
            tab.addEventListener('click', function () {
                tabs.forEach(t => t.classList.remove('active'));
                this.classList.add('active');
                const role = this.getAttribute('data-role');
                roleInput.value = role;
                
                // Update placeholder text based on role
                const usernameField = document.getElementById('usernameOrEmail');
                if (usernameField) {
                    if (role === 'STUDENT') {
                        usernameField.placeholder = 'Enter Roll Number or Student Email';
                    } else if (role === 'COMPANY') {
                        usernameField.placeholder = 'Enter Company HR Email or Username';
                    } else if (role === 'ADMIN') {
                        usernameField.placeholder = 'Enter Admin Username (admin)';
                    }
                }
            });
        });
    }

    // 2. Status Update Modal handler for Recruiters & Admin
    const statusModal = document.getElementById('statusModal');
    const closeBtn = document.querySelector('.close-modal');
    
    if (closeBtn && statusModal) {
        closeBtn.addEventListener('click', function () {
            statusModal.classList.remove('active');
        });
    }

    window.openStatusModal = function (appId, currentStatus, currentRemarks) {
        if (!statusModal) return;
        document.getElementById('modalAppId').value = appId;
        const select = document.getElementById('modalStatus');
        if (select) select.value = currentStatus;
        const remarksInput = document.getElementById('modalRemarks');
        if (remarksInput) remarksInput.value = currentRemarks || '';
        statusModal.classList.add('active');
    };

    window.closeStatusModal = function () {
        if (statusModal) statusModal.classList.remove('active');
    };

    // Close modal when clicking outside content
    window.addEventListener('click', function (e) {
        if (statusModal && e.target === statusModal) {
            statusModal.classList.remove('active');
        }
    });

    // 3. Confirm Delete Prompts
    const deleteLinks = document.querySelectorAll('.confirm-delete');
    deleteLinks.forEach(link => {
        link.addEventListener('click', function (e) {
            const itemName = this.getAttribute('data-item') || 'this item';
            if (!confirm(`Are you sure you want to delete ${itemName}? This action cannot be undone.`)) {
                e.preventDefault();
            }
        });
    });
});
