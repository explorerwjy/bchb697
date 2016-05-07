<?php
if (isset($_POST['submit1'])) 
{
	require_once "dbConnection.php";
	$length_1 = mysqli_real_escape_string($connection, htmlentities($_POST["length_1"]));
	$length_2 = mysqli_real_escape_string($connection, htmlentities($_POST["length_2"]));
	$mass_1 = mysqli_real_escape_string($connection, htmlentities($_POST["mass_1"]));
	$mass_2 = mysqli_real_escape_string($connection, htmlentities($_POST["mass_2"]));
}
?>
<?php
// use a stored procedure to get the data from db
if(!empty($connection))
{
		if ($length_1 == "") {
			$length_1 = 0;
		}
		if ($length_2 == "") {
			$length_2 = 100000;
		}
		if ($mass_1 == "") {
			$mass_1 = 0;
		}
		if ($mass_2 == "") {
			$mass_2 = 100000;
		}
		$query = "call protein_longer_than(" . $length_1 .','. $length_2 . ',' . $mass_1 . ',' . $mass_2 .')';
		#echo $query."<br/>";
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
        Customers.html
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

	<form id="form1" action="<?php echo $_SERVER['PHP_SELF']; ?>" method="POST" >

	<p>Find proteins whose length and mass within a certain range:<br>
	<input type="text" placeholder="Enter min length" name="length_1"
	<?php
		if(!empty($connection))
		{
			echo 'value="' . $length_1 .'"'; 
		} 
	?>/>
	<input type="text" placeholder="Enter max length" name="length_2"
	<?php
		if(!empty($connection))
		{
			echo 'value="' . $length_2 .'"'; 
		} 
	?>
	/>
	<input type="text" placeholder="Enter min mass" name="mass_1"
	<?php
		if(!empty($connection))
		{
			echo 'value="' . $mass_1 .'"'; 
		} 
	?>
	/>
	<input type="text" placeholder="Enter max mass" name="mass_2"
	<?php
		if(!empty($connection))
		{
			echo 'value="' . $mass_2 .'"'; 
		} 
	?>
	/>
	</p>
	
	<input type="submit" name="submit1" class="submit" value="Get data" />
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
				echo "No proteins meet condition of $length_1&ltlength&lt$length_2 and $mass_1&ltmass&lt$mass_2 are in this database.";
			} else
			{
				echo '<table class="table1">';
				echo '<caption>
					These proteins have ' .$length_1.'&ltlength&lt'.$length_2.' and ' .$mass_1 .'&ltmass&lt'.$mass_2 ; 
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