@tool
extends EditorExportPlugin

var exporting: bool
var export_path: String

const JS_METRIKA_CODE = """
<!-- Yandex.Metrika counter -->
<script type="text/javascript" >
   (function(m,e,t,r,i,k,a){m[i]=m[i]||function(){(m[i].a=m[i].a||[]).push(arguments)};
   m[i].l=1*new Date();
   for (var j = 0; j < document.scripts.length; j++) {if (document.scripts[j].src === r) { return; }}
   k=e.createElement(t),a=e.getElementsByTagName(t)[0],k.async=1,k.src=r,a.parentNode.insertBefore(k,a)})
   (window, document, "script", "https://mc.yandex.ru/metrika/tag.js", "ym");

   ym(101336789, "init", {
		clickmap:true,
		trackLinks:true,
		accurateTrackBounce:true
   });
</script>
<noscript><div><img src="https://mc.yandex.ru/watch/101336789" style="position:absolute; left:-9999px;" alt="" /></div></noscript>
<!-- /Yandex.Metrika counter -->
"""


func _get_name() -> String:
	return "YandexMetrika"


func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	if features.has("yandex-metrika"):
		exporting = true
		export_path = path


func _export_end() -> void:
	if exporting:
		var file := FileAccess.open(export_path, FileAccess.READ)
		var html := file.get_as_text()
		file.close()
		var pos = html.find('</head>')

		html = html.insert(
			pos,
			JS_METRIKA_CODE + "\n"
		)

		file = FileAccess.open(export_path, FileAccess.WRITE)
		file.store_string(html)
		file.close()
