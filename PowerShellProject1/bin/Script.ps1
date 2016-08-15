# Pre-Initialization
Split-Path -Parent $PSCommandPath | Set-Location

# Initialization
[xml]$xamlMainWindow = ($(Get-Content ".\GUI\MainWindow.xaml") -join "`r`n").Replace('x:Class="PowerShellProject1.MainWindow"', "").Replace('mc:Ignorable="d"', "")

#[xml]$xaml = @"
#	<Window x:Class="WpfApplication1.MainWindow"
#	        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
#	        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
#	        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
#	        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
#	        xmlns:local="clr-namespace:WpfApplication1"
#	        mc:Ignorable="d"
#	        Title="MainWindow" Height="350" Width="525">
#	    <Grid>
#	        <Button x:Name="button" Content="Button" HorizontalAlignment="Left" Margin="177,112,0,0" VerticalAlignment="Top" Width="75"/>
#	    </Grid>
#	</Window>
#"@.Replace('x:Class="WpfApplication1.MainWindow"', "").Replace('mc:Ignorable="d"', "")

# Post-Initialization
$reader=(New-Object System.Xml.XmlNodeReader $xamlMainWindow)
$Window=[Windows.Markup.XamlReader]::Load($reader)


# Main
$Window.ShowDialog()
