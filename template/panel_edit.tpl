[% IF access.edit_content %]
<div id="myNicPanel" style="position: fixed; z-index: 900; width:100%;"></div>
<div style="height: 25px;"></div>
<div id="myNicPanel_info" style="position: fixed; z-index: 900; width:100%; text-align:center; background-color: #CFB;"></div>
<script type="text/javascript">
    function show_info( t ) {
        if ( t ) {
            $('#myNicPanel_info').text( t );
            $("#myNicPanel_info").show('blind', {}, 500);
            setTimeout(function() {
                $("#myNicPanel_info").hide('blind', {}, 500)
            }, 3000);
        } else {
            $("#myNicPanel_info").hide();
        }
    };
    $(document).ready(function(){
        show_info('');
    });
</script>
[% END %]
