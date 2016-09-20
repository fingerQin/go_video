<!DOCTYPE html>
<html>
  <head>
    <title>自助教育系统</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
	<meta name="author" content="">
	
    <link rel="stylesheet" href="/static/themes/default/css/bootstrap.css">
  </head>
  	<body>


	<form action="/system/uploadfile" method="POST" enctype="multipart/form-data">
	文件：<input type="file" name="file" value="" />
	<input type="submit" name="submit" value="上传" />
	</form>

    <script src="/static/themes/default/js/jquery.js"></script>
    <script src="/static/themes/default/js/bootstrap.min.js"></script>
  </body>
</html>