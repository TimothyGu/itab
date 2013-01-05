<?php
require 'scripts/tabroomtemplate.html';
?>

<div class="liblrow block padmore">
<strong><center>RESULTS LAUNCH PAGE</CENTER></strong></br>
INSTRUCTIONS: Select the event from the list below and click on the corresponding link for sorted results or traditional cume sheets.  From the sortable results, you can click on any team name for a full listing of their round-by-round results.  
The seasonal totals link will show all teams' cumulative record, and provide links to an NDT bid sheet for any team.  The results received link will show what results have been recieved, which are still missing, and any known anomalies.</br></br>
<a href='https://www.tabroom.com/jbruschke/SeasonalTotals.php'>Seasonal Totals</a>
<a href='https://www.tabroom.com/jbruschke/CEDAChecker.php'>CEDA Points</a>
<a href='https://www.tabroom.com/jbruschke/NDTChecker.php'>NDT Points</a>
<a href='https://www.tabroom.com/jbruschke/PartCharts.php'>Participation Charts</a>
<a href='https://www.tabroom.com/jbruschke/ResultsStatus.php'>Results Received and Missing</a></br></br>

</div>

<table id="sortme" class="hovertable sortable" border="2" cellspacing="2" cellpadding="2">

	<thead>
		<tr class="yellowrow">
			<th>Tournament</th>
			<th>Division</th>
			<th>Sorted team list</th>
			<th>Traditional cume sheets</th>
			<th>Elim results</th>
			<th>Speaker Awards</th>
		</tr>

	</thead>
	<tbody>

<?php                    

require 'scripts/databaseconnect.php';

$query="SELECT *, event.name as event_name, tourn.name as tourn_name, tourn.id as tourn_id, event.id as event_id from event, tourn, tourn_circuit where circuit=43 and tourn_circuit.tourn=tourn.id and event.tourn=tourn.id and event.type='policy' order by tourn.start, tourn.id, event.type asc";
$event=mysql_query($query);
$eventNum = mysql_num_rows($event);

//loop entries
$i=0;
while ($i < $eventNum) {
echo "<tr><td>".mysql_result($event,$i,"tourn_name")."</td><td>". mysql_result($event,$i,"event_name")."</td><td><a href='https://www.tabroom.com/index/tourn/results/ranked_list.mhtml?event_id=".mysql_result($event,$i,"event_id")."&tourn_id=". mysql_result($event,$i,"tourn_id")."'>Sorted List</a></td><td><a href='https://www.tabroom.com/jbruschke/TableMaker.php?event=".mysql_result($event,$i,"event_id")."'>Cume sheets</a></td><td><a href='https://www.tabroom.com/jbruschke/ElimBracket.php?event=".mysql_result($event,$i,"event_id")."'>Elim Results</a></td><td><a href='https://www.tabroom.com/jbruschke/SpeakerAwards.php?event=".mysql_result($event,$i,"event_id")."'>Speaker Awards</a></td></tr>";
$i++;
}

?>

	</tbody>
</table>
</body>
</html>
