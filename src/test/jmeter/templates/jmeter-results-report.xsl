<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	
<xsl:output method="html" indent="yes" encoding="US-ASCII" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />

<xsl:template match="testResults">
	<html>
		<head>
			<title>Print Receipt API Test Results</title>
			<style type="text/css">
				body {
					font:normal 12 Calibri;
					color:#000000;
				}
				table tr td, table tr th {
					font-size: 12;
				}
				table.details tr th{
					font-weight: bold;
					text-align:left;
					background:#a6caf0;
					white-space: nowrap;
				}
				table.details tr td{
					background:#eeeee0;
					white-space: nowrap;
				}
				h3 {
					margin: 0px 0px 5px; font: 20 Calibri
				}
				h4 {
					margin-top: 1em; margin-bottom: 0.5em; font: bold 16 Calibri
				}
				.Failure {
					font-weight:bold; color:red;
				}
			</style>
		</head>
		<body>
		
			<xsl:call-template name="pageHeader" />
			
			<xsl:call-template name="serverdetails"/>
			<hr size="1" width="95%" align="left" />
	
			<xsl:call-template name="summary" />
			<hr size="1" width="95%" align="left" />

			<xsl:call-template name="pagelist" />

		</body>
	</html>
</xsl:template>

<xsl:template name="pageHeader">
	<h3>Print Receipt API Test Results</h3>
	<table width="100%">
		<tr>
			<td align="left"></td>
			<td align="right"></td>
		</tr>
	</table>
	<hr size="1" />
</xsl:template>

<xsl:template name="serverdetails">
<h4><u>Server Details</u></h4>
<table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
		<tr valign="top">
			<th>Server Name</th>
			<th>Port</th>
			<th>Path</th>
		</tr>
		
		<tr valign="top">
			<td>mcplab407p.stag.ch4.s.com</td>
			<td>8180</td>
			<td>/ess-register-services/receipt/format/v1</td>
		</tr>
</table>
</xsl:template>

<xsl:template name="summary">
	<h4><u>Summary</u></h4>
	<table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
		<tr valign="top">
			<th>Tests</th>
			<th>Failures</th>
			<th>Success Rate</th>
			<th>Total Time</th>
			<th>Average Time</th>
		</tr>
		<tr valign="top">
			<xsl:variable name="allCount" select="count(/testResults/*)" />
			<xsl:variable name="allFailureCount" select="count(/testResults/*[attribute::s='false'])" />
			<xsl:variable name="allSuccessCount" select="count(/testResults/*[attribute::s='true'])" />
			<xsl:variable name="allSuccessPercent" select="$allSuccessCount div $allCount" />
			<xsl:variable name="allTotalTime" select="sum(/testResults/*/@t)" />
			<xsl:variable name="allTotalTimeMin" select="$allTotalTime div 60000" />			
			<xsl:variable name="allAverageTime" select="$allTotalTime div $allCount" />
			<xsl:variable name="allMinTime">
				<xsl:call-template name="min">
					<xsl:with-param name="nodes" select="/testResults/*/@t" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="allMaxTime">
				<xsl:call-template name="max">
					<xsl:with-param name="nodes" select="/testResults/*/@t" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="$allFailureCount &gt; 0">Failure</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<td>
				<xsl:value-of select="$allCount" />
			</td>
			<td>
				<xsl:value-of select="$allFailureCount" />
			</td>
			<td>
				<xsl:call-template name="display-percent">
					<xsl:with-param name="value" select="$allSuccessPercent" />
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="display-min">
					<xsl:with-param name="value" select="$allTotalTimeMin" />
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="display-time">
					<xsl:with-param name="value" select="$allAverageTime" />
				</xsl:call-template>
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template name="pagelist">
	<h4><u>Test Results</u></h4>
	<table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
		<tr valign="top">
			<th>Scenario</th>
			<th>Tests</th>
			<th>Failures</th>
			<th>Success Count</th>
			<th>Success Rate</th>
			<th>Average Time</th>
		</tr>

		<xsl:for-each select="/testResults/*[not(@lb = preceding::*/@lb)]">
			<xsl:variable name="label" select="@lb" />
			
			<!-- Sorting the order of displaying the results -->
			<xsl:sort select="@lb"/>
			
			<xsl:variable name="count" select="count(../*[@lb = current()/@lb])" />
			<xsl:variable name="failureCount" select="count(../*[@lb = current()/@lb][attribute::s='false'])" />
			<xsl:variable name="successCount" select="count(../*[@lb = current()/@lb][attribute::s='true'])" />
			<xsl:variable name="successPercent" select="$successCount div $count" />
			<xsl:variable name="totalTime" select="sum(../*[@lb = current()/@lb]/@t)" />
			<xsl:variable name="averageTime" select="$totalTime div $count" />
			<xsl:variable name="minTime">
				<xsl:call-template name="min">
					<xsl:with-param name="nodes" select="../*[@lb = current()/@lb]/@t" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="maxTime">
				<xsl:call-template name="max">
					<xsl:with-param name="nodes" select="../*[@lb = current()/@lb]/@t" />
				</xsl:call-template>
			</xsl:variable>
			<tr valign="top">
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="$failureCount &gt; 0">Failure</xsl:when>
					</xsl:choose>
				</xsl:attribute>
				<td>
					<xsl:value-of select="$label" />
				</td>
				<td>
					<xsl:value-of select="$count" />
				</td>
				<td>
					<xsl:value-of select="$failureCount" />
				</td>
				<td>
					<xsl:value-of select="$successCount" />
				</td>
				<td>
					<xsl:call-template name="display-percent">
						<xsl:with-param name="value" select="$successPercent" />
					</xsl:call-template>
				</td>
				<td>
					<xsl:call-template name="display-time">
						<xsl:with-param name="value" select="$averageTime" />
					</xsl:call-template>
				</td>
			</tr>
		</xsl:for-each>
	</table>
</xsl:template>

<xsl:template name="min">
	<xsl:param name="nodes" select="/.." />
	<xsl:choose>
		<xsl:when test="not($nodes)">NaN</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="$nodes">
				<xsl:sort data-type="number" />
				<xsl:if test="position() = 1">
					<xsl:value-of select="number(.)" />
				</xsl:if>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="max">
	<xsl:param name="nodes" select="/.." />
	<xsl:choose>
		<xsl:when test="not($nodes)">NaN</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="$nodes">
				<xsl:sort data-type="number" order="descending" />
				<xsl:if test="position() = 1">
					<xsl:value-of select="number(.)" />
				</xsl:if>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="display-percent">
	<xsl:param name="value" />
	<xsl:value-of select="format-number($value,'0.00%')" />
</xsl:template>

<xsl:template name="display-time">
	<xsl:param name="value" />
	<xsl:value-of select="format-number($value,'0 ms')" />
</xsl:template>

<xsl:template name="display-min">
	<xsl:param name="value" />
	<xsl:value-of select="format-number($value,' (00.00 mins)')" />
</xsl:template>

</xsl:stylesheet>