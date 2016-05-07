<!DOCTYPE html>
<!-- WebsiteHowToDeploy.html 
This is a comment. Comments are not displayed in the browser
-->
<html>
<head>
    <title>
        WebsiteHowToDeploy.html
    </title>
    <link rel="stylesheet" type="text/css" HREF="./css/StyleSheets.css"/>
    <link rel="stylesheet" type="text/css" HREF="./css/navigation.css"/>
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
    Instructions to deploy my web application
	<br><br>
	<input Type="button" value="Go Back to Website Documentation Page" onclick="window.location.href='WebsiteDocs.php'"> 

</h1>
<hr>

<details>
  <summary>System requirements</summary>
  <p>A Web Broswer (e.g. Chrome, Firefox)</p>
  <p>XAMPP with Module of Apache and MySQL</p>
  <p>Operating System of Window, Mac OS X or Linux</p>
  <p>Memory of 2G</p>
</details><br>

<details>
  <summary>Restore the database</summary>
  <p>1.Run The XAMPP Control Panel</p>
  <p>2.Start the Module of "Apache" and "MySQL". Make sure the port(s) not been taken</p>
  <p>3.Open the configuration file php.ini, make sure that 
    <li>post_max_size>=200M</li>
    <li>upload_max_filesize>=100M</li>
    <li>memory_limit>=100M</li>
    <p>So there will be enough space for the database.</p>
  </p>
  <p>4.Click on "Admin" button of MySQL, open the phpmyadmin with webbroswer.</p>
  <p>5.Click on "Import" button, select the database backup file, then Press Go button to run the script</p>
  <p>6.Now we can query the database via phpmyadmin</p>
</details><br>

<details>
  <summary>Install the web code</summary>
  <p>Locatate where xampp installed, unzip the codes and put the folder under xampp/htdocs/BCHB697</p>
  <p>E.g: Codes in foler jw1509, put this folder under xampp/htdocs/BCHB697. We can access the main page via <a href="http://localhost/BCHB697/jw1509/ProjectPresentation.php" target="_blank">http://localhost/BCHB697/jw1509/ProjectPresentation.php </a></p>
</details><br>

<details>
  <summary>Database connection</summary>
  <p>Connection configuration in dbConnection.php</p>
  <p>dbhost ="localhost:3306"</p>
  <p>dbuser = "webmaster"</p>
  <p>dbpass = "root697"</p>
  <p>dbname = "jw1509_ptop"</p>
  <p>If configurations are correct, now we can access database from web application</p>
</details><br>

<details>
  <summary>Where to keep files that support the website</summary>
  <p>Images stores at /images folder</p>
  <p>Style Shhets stores at /css folder</p>
  <p>JavaScripts stores at /js folder</p>
  <p>Other files support the website stores at /archive folder, such as EER digram, database backup file and raw data</p>
</details><br>

<details>
  <summary>How to test the website to ensure a successful deployment</summary>
  <p>Click on every button and link to make sure website works fine</p>
  <p>Use different query to make sure database will give a reasonable result</p>
</details><br>

<br>
<br>
</section>

</body>
</html>
