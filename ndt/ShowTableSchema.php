<?php
$username="jbruschke";
$password="Oof9iyeeGh9jeeg";
$database="itab";

mysql_connect("localhost",$username,$password);
@mysql_select_db($database) or die( "Unable to select database<br>");

$result = mysql_query("SHOW COLUMNS FROM entry_student");
if (!$result) {
    echo 'Could not run query: ' . mysql_error();
    exit;
}
if (mysql_num_rows($result) > 0) {
    while ($row = mysql_fetch_assoc($result)) {
        print_r($row)."<br><br>";
    }
}

echo "<br>";

$query="SELECT distinct tag from ballot_value order by tag";
//$query="SELECT * from panel where panel.round is null and panel.id>=183219";
$tourn=mysql_query($query);
$entryNum = mysql_num_rows($tourn);

for ($i=0; $i <= $entryNum-1; $i++)
{
echo "tag=".mysql_result($tourn,$i,"tag")."<br>";
//echo mysql_result($tourn,$i,"panel.id")." ".mysql_result($tourn,$i,"room")." ".mysql_result($tourn,$i,"round")."<br>";
//$query2="delete from panel where panel.id=".mysql_result($tourn,$i,"panel.id");
//echo $query2;
//mysql_query($query2);
}

$query="SELECT * from INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'";
$tourn=mysql_query($query);
$entryNum = mysql_num_rows($tourn);

for ($i=0; $i <= $entryNum-1; $i++)
{
echo mysql_result($tourn,$i,"table_name")."<br>";
}

echo "<br>";

$sql = mysql_query("SELECT * FROM ballot_value where (ballot_value.ballot>=1679457 and ballot_value.ballot<=1679568) and ballot_value.tag='rfd'");
//$sql = mysql_query("SELECT * FROM ballot, round where ballot.round=round.id and round");
$tourn=mysql_query($query);
//$assoc = mysql_fetch_assoc($sql);
//var_dump($assoc);

$query="SELECT * FROM ballot_value where (ballot_value.ballot>=1679457 and ballot_value.ballot<=1679568) and ballot_value.tag='rfd'";
$query="SELECT * FROM chapter, chapter_circuit where chapter_circuit.circuit=43 and chapter.id=chapter_circuit.chapter order by name asc";

$tourn=mysql_query($query);
$entryNum = mysql_num_rows($tourn);
echo $entryNum."<br>";
for ($i=0; $i <= $entryNum-1; $i++)
{
echo mysql_result($tourn,$i,"id")." ".mysql_result($tourn,$i,"name")."<br>";
//echo mysql_result($tourn,$i,"panel.id")." ".mysql_result($tourn,$i,"room")." ".mysql_result($tourn,$i,"round")."<br>";
//$query2="delete from panel where panel.id=".mysql_result($tourn,$i,"panel.id");
//echo $query2;
//mysql_query($query2);
}

mysql_close();
?>
