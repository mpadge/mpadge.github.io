(function () {
    var container = document.getElementById('mastodon-comments');
    if (!container) return;

    var url = container.dataset.mastodonUrl;
    if (!url) return;

    var match = url.match(/^(https?:\/\/[^/]+)\/@[^/]+\/(\d+)$/);
    if (!match) return;
    var instance = match[1];
    var statusId = match[2];

    fetch(instance + '/api/v1/statuses/' + statusId + '/context')
        .then(function (r) { return r.json(); })
        .then(function (data) { render(data.descendants || [], statusId, url); })
        .catch(function () {});

    function relativeTime(isoStr) {
        var then = new Date(isoStr).getTime();
        var diff = Math.floor((Date.now() - then) / 1000);
        if (diff < 60) return diff + 's ago';
        if (diff < 3600) return Math.floor(diff / 60) + 'm ago';
        if (diff < 86400) return Math.floor(diff / 3600) + 'h ago';
        if (diff < 2592000) return Math.floor(diff / 86400) + 'd ago';
        if (diff < 31536000) return Math.floor(diff / 2592000) + 'mo ago';
        return Math.floor(diff / 31536000) + 'y ago';
    }

    function escapeHtml(str) {
        return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    function render(replies, rootId, rootUrl) {
        var direct = replies.filter(function (r) { return r.in_reply_to_id === rootId; });

        var section = document.getElementById('mastodon-comments-section');
        if (!section) return;

        if (direct.length === 0) {
            section.innerHTML =
                '<p class="mastodon-no-comments">No replies yet. ' +
                '<a href="' + escapeHtml(rootUrl) + '" target="_blank" rel="noopener noreferrer">Reply on Mastodon</a>' +
                '</p>';
            return;
        }

        var html = '<h3 class="mastodon-comments-heading">Replies</h3>';
        html += '<ul class="mastodon-comments-list">';

        direct.forEach(function (reply) {
            var acct = reply.account;
            var avatar = acct.avatar_static || acct.avatar || '';
            var displayName = escapeHtml(acct.display_name || acct.username);
            var handle = escapeHtml('@' + acct.acct);
            var profileUrl = escapeHtml(acct.url);
            var replyUrl = escapeHtml(reply.url);
            var time = relativeTime(reply.created_at);
            var content = reply.content;

            html += '<li class="mastodon-comment">';
            html +=   '<div class="mastodon-comment-header">';
            html +=     '<a href="' + profileUrl + '" target="_blank" rel="noopener noreferrer" class="mastodon-avatar-link">';
            html +=       '<img src="' + escapeHtml(avatar) + '" alt="" class="mastodon-avatar" width="40" height="40">';
            html +=     '</a>';
            html +=     '<div class="mastodon-comment-meta">';
            html +=       '<a href="' + profileUrl + '" target="_blank" rel="noopener noreferrer" class="mastodon-display-name">' + displayName + '</a>';
            html +=       '<span class="mastodon-handle">' + handle + '</span>';
            html +=     '</div>';
            html +=     '<a href="' + replyUrl + '" target="_blank" rel="noopener noreferrer" class="mastodon-timestamp">' + time + '</a>';
            html +=   '</div>';
            html +=   '<div class="mastodon-comment-content">' + content + '</div>';
            html += '</li>';
        });

        html += '</ul>';
        html += '<p class="mastodon-reply-link"><a href="' + escapeHtml(rootUrl) + '" target="_blank" rel="noopener noreferrer">Reply on Mastodon</a></p>';

        section.innerHTML = html;
    }
}());
