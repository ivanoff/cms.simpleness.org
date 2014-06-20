[% FOREACH comment IN comments %]
    <div class="commentWrapperf" id="[% comment.comment_position * 1000000 %]">
      <div id="commentf">
        <form>
        <p class="formrow">[% comment.comment_body %]</p>
        </form>
      </div>
    </div>
[% END %]