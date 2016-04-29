<!DOCTYPE html>
<!-- DescribeData.html 
This is a comment. Comments are not displayed in the browser

-->

<html lang='en'>
<head>
    <meta charset="UTF-8" /> 
    <title>
        DescribeData.html
    </title>
    <link rel="stylesheet" type="text/css" HREF="./css/StyleSheets.css"/>
    <link rel="stylesheet" type="text/css" HREF="./css/navigation.css"/>
    <!--link rel="stylesheet" type="text/css" HREF="StyleSheetBCHB697.css" -->
</head>
<body>
   <nav>
      <a href="ProjectPresentation.php">Home Page</a>
      <a href="WebsiteDocs.php">My website documentation</a>
      <a href="BioinformaticsReport.php">Bioinformatics reports</a>
      <a href="FutureWork.php">Future work</a>
      <a href="https://github.com/explorerwjy" target="_blank">Contact</a>
    </nav>
<section>
<h1>
    My bioinformatics data set
	<br><br>
	<input Type="button" value="Go Back to Website Documentation Page" onclick="window.location.href='WebsiteDocs.php'"> 
</h1>
<br>
<hr>

<ul>
	<li> <b>What is my data set?</b>
	<p> My data is Proteins and it's related genes that have relation with several diseases.</p>
	<ul>
	<a href="./archive/data.xlsx" download><b>Download the UniverseTable</b></a><br>
	<a href="./archive/protein.csv" download><b>Download the Protein Table</b></a><br>
	<a href="./archive/protein_name.csv" download><b>Download the Protein Names Table</b></a><br>
	<a href="./archive/gene.csv" download><b>Download the Gene Table</b></a><br>
	<a href="./archive/gene_name.csv" download><b>Download the Gene name Table</b></a><br>
	<a href="./archive/mim.csv" download><b>Download the MIM phenotype Table</b></a><br>
	<a href="./archive/mim_to_do.csv" download><b>Download the MIM to Disease Ontology Table</b></a><br>
	<a href="./archive/disease_short_name.csv" download><b>Download the Disease Short Name Table</b></a><br>
	<a href="./archive/do.csv" download><b>Download the Disease Ontology Table</b></a>
	</ul>
	</li>
	
	<li> <b>Why did I select this data set?</b>
	<p> These data can provide molecular information about diseases we care about.
	</p></li>

	
	<li> <b>Where and how did I collect this data set?</b>
	<p> My data collected from Three web site:</p>
		<ul>
		<li><a href="http://www.uniprot.org/" target="_blank">UniProt</a></li>
		<li><a href="http://www.genenames.org/" target="_blank">HGNC database of human gene names</a></li>
		<li><a href="http://www.omim.org/" target="_blank">Online Mendelian Inheritance in Man</a></li>
		<li><a href="http://disease-ontology.org/" target="_blank">Disease Ontology</a></li>
	</ul>
	<p>I use python to scrape the data with <a href="https://www.crummy.com/software/BeautifulSoup/" target="_blank">BeautifulSoup</a>
	<p/>
	
	</li>

	<li> <b>What are the buisness rules or specifications of my data set?</b>
	<p> This database is to track the various issues that are related to several diseases and their related proteins as well as related genes.
	<a href="./archive/BusinessRules.pdf" target="_blank" ><b>Lick here to View Descriptions</b></a>
	</li>
</ul>
</section>

</body>
</html>