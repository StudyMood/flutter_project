document.addEventListener('DOMContentLoaded', () => {
    
    // --- Hero Typing Effect ---
    const words = [
        "a Flutter Developer.",
        "a Dart Enthusiast.",
        "an Android Developer.",
        "a Problem Solver."
    ];
    let wordIndex = 0;
    let charIndex = 0;
    let isDeleting = false;
    const typingDelay = 100;
    const erasingDelay = 60;
    const newWordDelay = 2000;
    const typingSpan = document.getElementById('typing-text');

    function type() {
        const currentWord = words[wordIndex];
        
        if (isDeleting) {
            typingSpan.textContent = currentWord.substring(0, charIndex - 1);
            charIndex--;
        } else {
            typingSpan.textContent = currentWord.substring(0, charIndex + 1);
            charIndex++;
        }

        if (!isDeleting && charIndex === currentWord.length) {
            isDeleting = true;
            setTimeout(type, newWordDelay);
        } else if (isDeleting && charIndex === 0) {
            isDeleting = false;
            wordIndex = (wordIndex + 1) % words.length;
            setTimeout(type, 500);
        } else {
            setTimeout(type, isDeleting ? erasingDelay : typingDelay);
        }
    }

    if (typingSpan) {
        setTimeout(type, 1000);
    }

    // --- Navigation Links Highlighting on Scroll ---
    const sections = document.querySelectorAll('section[id]');
    const navLinks = document.querySelectorAll('.nav-link');

    window.addEventListener('scroll', () => {
        let scrollY = window.pageYOffset;
        
        sections.forEach(current => {
            const sectionHeight = current.offsetHeight;
            const sectionTop = current.offsetTop - 120;
            const sectionId = current.getAttribute('id');
            
            if (scrollY > sectionTop && scrollY <= sectionTop + sectionHeight) {
                navLinks.forEach(link => {
                    link.classList.remove('active');
                    if (link.getAttribute('href') === `#${sectionId}` || (sectionId === 'home' && link.getAttribute('href') === '#')) {
                        link.classList.add('active');
                    }
                });
            }
        });
    });

    // --- Copy to Clipboard ---
    const copyButtons = document.querySelectorAll('.copy-btn');
    copyButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            const textToCopy = btn.getAttribute('data-copy');
            if (textToCopy) {
                navigator.clipboard.writeText(textToCopy).then(() => {
                    const originalText = btn.textContent;
                    btn.textContent = 'Copied!';
                    btn.classList.add('copied');
                    
                    setTimeout(() => {
                        btn.textContent = originalText;
                        btn.classList.remove('copied');
                    }, 2000);
                }).catch(err => {
                    console.error('Could not copy text: ', err);
                });
            }
        });
    });

    // --- Contact Form Submission Simulation ---
    const contactForm = document.getElementById('contact-form');
    const formStatus = document.getElementById('form-status');

    if (contactForm) {
        contactForm.addEventListener('submit', (e) => {
            e.preventDefault();
            
            const submitBtn = document.getElementById('form-submit-btn');
            const originalBtnText = submitBtn.textContent;
            
            // Show loading state
            submitBtn.disabled = true;
            submitBtn.textContent = 'Sending Message...';
            submitBtn.style.opacity = '0.7';
            
            // Simulate message delivery API delay
            setTimeout(() => {
                // Success message
                formStatus.textContent = 'Thank you! Your message has been sent successfully.';
                formStatus.className = 'form-status success';
                
                // Clear input boxes
                contactForm.reset();
                
                // Restore button
                submitBtn.disabled = false;
                submitBtn.textContent = originalBtnText;
                submitBtn.style.opacity = '1';
                
                // Close status report after 5 seconds
                setTimeout(() => {
                    formStatus.style.display = 'none';
                    formStatus.className = 'form-status';
                    formStatus.textContent = '';
                }, 5000);
            }, 1200);
        });
    }
});
