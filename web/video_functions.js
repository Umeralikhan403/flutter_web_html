function createSmallVideoElement(url) {
    // Check if an element with id 'small-video' already exists and remove it
    var existingVideo = document.getElementById('small-video');
    if (existingVideo) {
        existingVideo.remove();
    }

    var video = document.createElement('video');
    video.id = 'small-video';
    video.src = url;
    video.autoplay = true;
    video.muted = true; // Mute the video to allow autoplay
    video.style.position = 'absolute';
    video.style.right = '10px'; // Position right 10px
    video.style.bottom = '10px'; // Position bottom 10px
    video.style.width = '200px'; // Set width
    video.style.height = '90px'; // Set height
    video.setAttribute('playsinline', ''); // Ensure inline playback in iOS
    document.body.appendChild(video); // Append to body
    video.load(); // Start loading the video

    // Add an 'ended' event listener to the video element
    video.addEventListener('ended', function () {
        // Video has finished playing
        // This will call the Dart function 'onVideoEnd'
        if (typeof window.onVideoEnd === 'function') {
            window.onVideoEnd();
        }
    });
}

function removeSmallVideoElement() {
    var video = document.getElementById('small-video');
    if (video) {
        video.remove();
    }
}
