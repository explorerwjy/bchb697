<?php
if (isset($_POST['submit1']) && !empty($_POST['disease_name'])) 
{
	require_once "dbConnection.php";
	$disease_name = mysqli_real_escape_string($connection, htmlentities($_POST["disease_name"]));
}
?>

<?php
if(!empty($connection))
{
		$query = "call search_disease_name(" . '"' . $disease_name . '")';
		//echo $query."<br/>";
		$result = mysqli_query($connection, $query);
		if (!$result)
		{
			die("Database query failed.");
		}
}		
?>
<!DOCTYPE html>
<!-- scCustomers.html 
This is a comment. Comments are not displayed in the browser
-->

<html lang='en'>
<head>
    <meta charset="UTF-8" /> 
    <title>
        Procedure3.html
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
		Use jw1509_ptop Database
		<br><br>
		<input Type="button" value="Go Back to Search Indexes Page" onclick="window.location.href='BioinformaticsReport.php'"/> 
	</h1>
	<br>
	<hr>

	<form name="form1" method="POST" action="<?php echo $_SERVER['PHP_SELF']; ?>" >

	<p>Find disease related proteins:
	<input type="text" placeholder="Enter a Disease name" name="disease_name"
		<?php
		if(!empty($connection))
		{
			echo 'value="' . $disease_name .'"'; 
		} 
		?>
	/>
	</p>
	<input type="submit" name="submit1" class="submit" value="Submit" />
	
</form>


<?php
	if (!empty($connection))
	{	
			$NumOfRows = mysqli_num_rows($result);
			$Index = 0;
			//echo "Number of rows = $NumOfRows"."<br/>";
			//echo "check row count <br/>";
			//echo (false);
			//echo ($NumOfRows);

			if ($NumOfRows == 0)
			{
				echo "No proteins related to disease name <u>$disease_name</u>.";
			} else
			{
				echo '<table class="table1">';
				echo '<caption>
					proteins related to disease name ';
				echo '"' . $disease_name . '"'; 
				echo "</caption>";
				echo "<thead>
						<tr>";
				$row = mysqli_fetch_assoc($result);
				//print_r ($row);
				
				foreach($row as $k => $v ) 
				{       
					echo "<th>".$k."</th>";
				}
			
				echo "	</tr>
					</thead>
					<tbody>";

				$check = mysqli_data_seek($result, 0);
				
				 while ($rownew = mysqli_fetch_assoc($result))
				 {
					echo "<tr>";
					foreach($rownew as $k => $v)
					{
					echo "<td>".$v."</td>";
					}
					echo "</tr>";	
				 }
				 
				echo "	</tbody>
					</table>";
			}
	}
	?>
	
	<?php
		if(!empty($connection))
		{
			mysqli_free_result($result);
		}
	?>

</section>
</body>
</html>
<?php
	// close database connection
	if(!empty($connection))
	{
		mysqli_close($connection);
	}
?>