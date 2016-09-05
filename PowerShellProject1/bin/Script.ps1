# Startup
Split-Path -Parent $PSCommandPath | Set-Location

# Hide PowerShell Window
#$window = Add-Type -memberDefinition @"
#[DllImport("user32.dll")]
#public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
#"@ -name "Win32ShowWindowAsync" -namespace Win32Functions -PassThru;
#$window::ShowWindow((Get-Process –id $pid).MainWindowHandle, 0);

# Pre-Initialization
Add-Type -AssemblyName presentationframework
[xml]$xamlMainWindow = ($(Get-Content ".\GUI\MainWindow.xaml") -join "`r`n").Replace('x:Class="PowerShellProject1.MainWindow"', "").Replace('mc:Ignorable="d"', "")

# Initialization
$reader=(New-Object System.Xml.XmlNodeReader $xamlMainWindow)
$Window=[Windows.Markup.XamlReader]::Load($reader)

# Post-Initialization
$Window.FindName("radioButton").Add_Click({Write-Host "RadioButton pressed"})
# Get all possible propertys
# $Window.FindName("button") | Get-member Add* -MemberType Method -force | Sort-Object Name | Format-Table -AutoSize
$Window.FindName("radioButton1").IsChecked = $true
$Window.FindName("radioButton2").IsEnabled = $false
$Window.FindName("textBox").set_Text("Hello")
$Window.FindName("textBox").Add_TextChanged({Write-Host "TextChanged"})
$Window.FindName("button").Add_Click( {
		Write-Host "Button pressed"
		if($Window.FindName("radioButton").IsChecked)
		{
			Write-Host "radoButton was checked"
		} elseif($Window.FindName("radioButton1").IsChecked) {
			Write-Host "radoButton1 was checked"
		} elseif($Window.FindName("radioButton2").IsChecked) {
			Write-Host "radoButton2 was checked"
		} else {
			Write-Host "no radioButton was checked"
		}
		$Window.FindName("radioButton3").set_Visibility([System.Windows.Visibility]::Visible)
} )
$Window.Add_SourceInitialized( {
    ## Before the window's even displayed ...
    ## We'll create a timer
    $timer = new-object System.Windows.Threading.DispatcherTimer
    ## Which will fire every second
    $timer.Interval = [TimeSpan]"0:0:01"
    ## And will invoke the $updateBlock
    $timer.Add_Tick( $updateBlock )
    ## Now start the timer
    $timer.Start()
 } )
 $count = 0
 $updateBlock = { Write-Host $count; ([ref]$count).Value++; }

# Render GUI
$Window.ShowDialog()
