<?php
if (isset($_POST["submit1"]) && !empty($_POST["n_name"]) )
{
	require_once "dbConnection.php";
	$n_name = $_POST["n_name"];
}
?>

<?php
if(!empty($connection))
{
		$query = "call protein_with_many_names(" . '"' . $n_name .'"'.')';
		$result = mysqli_query($connection, $query);
		if (!$result)
		{
			die("Database query failed.");
		}
}
?>

<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charset="UTF-8" /> 
    <title>
        altNames
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
	<input Type="button" value="Go Back to Report Page" onclick="window.location.href='BioinformaticsReport.php'">
	</h1>
	<br>
	<hr>

	<form id="form2" action="<?php echo $_SERVER['PHP_SELF']; ?>" method="post">
	<p> Find which proteins have equal or more than n alt names </P>
	<select style="margin-left:280px" name="n_name">
  	<option 
  		<?php
			if(!empty($connection))
			{
				echo 'value="' . $n_name .'"'; 
			} else
			{
				echo 'value="" selected disabled';
			}
		?>
  	>
  		<?php
			if(!empty($connection))
			{
				echo ($n_name); 
			} else
			{
				echo 'Select a store';
			}
	 	?> 
  	</option>
	  <option value="" selected disabled >Select a number</option> 
	  <option value="1">1</option>
	  <option value="2">2</option>
	  <option value="3">3</option>
	  <option value="4">4</option>
	  <option value="5">5</option>
	  <option value="8">8</option>
	</select>
	<br>
	<input type="submit" name="submit1" class="submit" value="Go" />
	</form>
	<hr>
	<br>
	<!--/* the class name is case sensitive.*/ -->
	<table class="table1">
	<!--table-->


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
				echo "No proteins have equal or more <u>$n_name</u> are in this database.";
			} else
			{
				echo '<table class="table1">';
				echo '<caption>
					These proteins have equal or more than '. $n_name .' names'; 
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