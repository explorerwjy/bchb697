<!DOCTYPE html>
<!-- scCustomers.html 
This is a comment. Comments are not displayed in the browser
-->

<html lang='en'>
<head>
    <meta charset="UTF-8" /> 
    <title>
        Customers.html
    </title>
    <link rel="stylesheet" type="text/css" HREF="./css/StyleSheets.css"/>
    <link rel="stylesheet" type="text/css" HREF="./css/navigation.css"/>
</head>
<body>
	<nav>
	  <a href="ProjectPresentation.html">Home Page</a>
      <a href="WebsiteDocs.html">My website documentation</a>
      <a href="scIndex.html">Bioinformatics reports</a>
      <a href="FutureWork.html">Future work</a>
      <a href="">Contact</a>
    </nav>
    <section>
	<h1>
		Use Sakila Database
		<br><br>
		<input Type="button" value="Go Back to Report Page" onclick="window.location.href='scIndex.html'">
	</h1>
	<br>
	<hr>

	<form id="form1" action="" method="get">

	<p>Report number of proteins with and without do information:
	<!-- <input type="text" placeholder="Enter a last name" name="lastname"> -->
	</p>
	
	<input type="submit" name="submit1" class="submit" value="Get data" />
	</form>
	<hr>
	<br>
	<!--/* the class name is case sensitive.*/ -->
	<table class="table1" >
	<!--table-->
		<caption>
			Number of proteins with and without do information
		</caption>
		<!-- make the first row a column header row-->
		<tr>
			<th> number of protein with do </th>
			<th> number of protein without do </th>
			<th> number of_mim with do </th>
			<th> number of_mim without do </th>
		</tr>
		<tr>
			<td style="text-align:center"> 19 </td>
			<td style="text-align:center"> 27 </td>
			<td style="text-align:center"> 22 </td>
			<td style="text-align:center"> 59 </td>
		</tr>

	</table>
</section>
</body>
</html>