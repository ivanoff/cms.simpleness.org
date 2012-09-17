<h2>Browse</h2>

    <script>
	document.createElement('figure');
	document.createElement('figcaption');
    </script>
    <style>
	figure {
	    background: #d9dabb; /* Цвет фона */
    	    display: block; /* Блочный элемент */
    	    width: 150px; /* Ширина */
    	    height: 190px; /* Высота */
    	    float: left; /* Блоки выстраиваются по горизонтали */
    	    margin: 0 10px 10px 0; /* Отступы */
    	    text-align: center; /* Выравнивание по центру */
        }
	figure img {
    	    border: 2px solid #8b8e4b; /* Параметры рамки */
    	}
    	figure p {
    	    margin-bottom: 0; /* Отступ снизу */
    	}
    </style>

<script type="text/javascript">
//    window.parent.CKEDITOR.tools.callFunction([% num %], '[% path %]/100.JPG', '100.JPG was uploaded'); 
</script>

<article>
[% FOREACH k IN fl %]
<figure>
    <img height="80" width="100" src="/[% k %]">
    <figcaption>
	[% k %]
	delete
	<input type="button" onclick="window.parent.CKEDITOR.tools.callFunction([% num %], '[% path %]/100.JPG', '100.JPG was uploaded');">
    </figcaption>
</figure>
[% END %]
</article>

