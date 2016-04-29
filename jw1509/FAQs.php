<?php
if (isset($_POST["submit1"]) && !empty($_POST["question"])) 
{
	require_once "dbConnection.php";
	$question = $_POST["question"];
	#echo ($question);
}
?>
<?php
if(!empty($connection))
{	
	if ($question == 1)
	{
		$query = 'call general_view()';
		$result = mysqli_query($connection, $query);
	}
	elseif ($question == 2)
	{
		$query = 'call look_mim()';
		$result = mysqli_query($connection, $query);
	}
	elseif ($question == 3)
	{
		$query = 'call look_do()';
		$result = mysqli_query($connection, $query);
	}
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
        scFAQs.html
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
	<form name="form1" method="POST" action="<?php echo $_SERVER['PHP_SELF']; ?>" >
	<p> Select one of the frequently asked questions: </p>

	<p> 	
	 <input type="radio" name="question" value="1" style ="margin-left:20px"
	 <?php	
		if(!empty($connection) && $question == 1)
		{
			echo " checked";
		}
	  ?>
	 /> View the proteins in this database at a scale. <br>
	<input type="radio" name="question" value="2" style ="margin-left:20px"
	<?php	
		if(!empty($connection) && $question == 2)
		{
			echo " checked";
		}
	 ?>	  
	/> According to each MIM phenotype in the database, find their number of related proteins and some useful information. &nbsp; <br> 
	<input type="radio" name="question" value="3" style ="margin-left:20px" 
	<?php	
		if(!empty($connection) && $question == 3)
		{
			echo " checked";
		}
	 ?>
	 /> Report number of proteins with and without do information  
	</p>

	<input type="submit" name="submit1" class="submit" value="Get An Answer" />
	</form>
	<hr>
	<br>
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
				echo "No data was found for the selected question.";
			} else
			{
				echo '<table class="table1">';
				echo '<caption>
					This is the answer for the selected question. ';
		
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