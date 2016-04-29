<!DOCTYPE html>
<!-- scFilms.html 
This is a comment. Comments are not displayed in the browser
-->

<html lang='en'>
<head>
    <meta charset="UTF-8" /> 
    <title>
        scFilms.html
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
		Use jw1509_ptop Database
					<br><br>
	<!-- <button Type="button"  onclick="window.location.href='scIndex.html'">Go Back to Report Search Index</button> -->
	<input Type="button" value="Go Back to Report Page" onclick="window.location.href='scIndex.html'">
	</h1>
	<br>
	<hr>

	<form id="form2" action="" method="post">
	<p> Get to Uniprot and HGNC given a protein name: </P>
	<select style="margin-left:280px" name="protein">
	  <option value="" selected disabled>Select a Protein</option> 
	  <option value="Interferon regulatory factor 4">Interferon regulatory factor 4</option>
	</select>
	<br>
	<input type="submit" name="submit2" class="submit" value="Go" />
	</form>
	<hr>
	<br>
	<!--/* the class name is case sensitive.*/ -->
	<table class="table1">
	<!--table-->
		<caption>
			Here are link to Uniprot and HGNC
		</caption>
		<!-- make the first row a column header row-->
		<tr>
			<th> protein_name </th>
			<th> Uniprot_entry_id </th>
			<th> UniprotHtmlLink </th>
			<th> HGNC_id </th>
			<th> HGNCHtmlLink </th>
		</tr>
		<tr>
			<td> Interferon regulatory factor 4 </td>
			<td> Q15306 </td>
			<td> <a href="http://www.uniprot.org/uniprot/Q15306" target="_blank"><b>Q15306</b> </td>
			<td> 6119 </td>
			<td> <a href="http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=6119" target="_blank"><b>6119</b> </td>
		</tr>

	</table>

	</section>
</body>
</html>