#Generated Form Function
function GenerateForm {
########################################################################
# Code Generated By: SAPIEN Technologies PrimalForms v1.0.2.0
# Generated On: 5/14/2009 10:44 AM
# Generated By: hbader
########################################################################

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
#endregion

#region Generated Form Objects
$form1 = New-Object System.Windows.Forms.Form
$butCancel = New-Object System.Windows.Forms.Button
$butTakeSnapshots = New-Object System.Windows.Forms.Button
$rbServerList = New-Object System.Windows.Forms.RadioButton
$rbTextInput = New-Object System.Windows.Forms.RadioButton
$lblPrefix = New-Object System.Windows.Forms.Label
$txtVMPrefix = New-Object System.Windows.Forms.TextBox
$lblComments = New-Object System.Windows.Forms.Label
$txtComments = New-Object System.Windows.Forms.TextBox
$openFileDialog1 = New-Object System.Windows.Forms.OpenFileDialog
#endregion Generated Form Objects

#----------------------------------------------
#Generated Event Script Blocks
#----------------------------------------------
#Provide Custom Code for events specified in PrimalForms.
$butTakeSnapshots_OnClick= 
{
#TODO: Place custom script here

}

$handler_textBox2_TextChanged= 
{
#TODO: Place custom script here

}

$handler_label1_Click= 
{
#TODO: Place custom script here

}

$handler_rbServerList_CheckedChanged= 
{
#TODO: Place custom script here

}

$handler_radioButton1_CheckedChanged= 
{
#TODO: Place custom script here

}

$handler_button2_Click= 
{
#TODO: Place custom script here

}

$handler_form1_Load= 
{
#TODO: Place custom script here

}

#----------------------------------------------
#region Generated Form Code
$form1.Text = 'SuperSnapShotter'
$form1.Name = 'form1'
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 519
$System_Drawing_Size.Height = 311
$form1.ClientSize = $System_Drawing_Size
$form1.add_Load($handler_form1_Load)

$butCancel.TabIndex = 7
$butCancel.Name = 'butCancel'
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 89
$System_Drawing_Size.Height = 23
$butCancel.Size = $System_Drawing_Size
$butCancel.UseVisualStyleBackColor = $True

$butCancel.Text = 'Cancel'

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 163
$System_Drawing_Point.Y = 259
$butCancel.Location = $System_Drawing_Point
$butCancel.DataBindings.DefaultDataSourceUpdateMode = 0
$butCancel.add_Click($handler_button2_Click)

$form1.Controls.Add($butCancel)

$butTakeSnapshots.TabIndex = 6
$butTakeSnapshots.Name = 'butTakeSnapshots'
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 92
$System_Drawing_Size.Height = 24
$butTakeSnapshots.Size = $System_Drawing_Size
$butTakeSnapshots.UseVisualStyleBackColor = $True

$butTakeSnapshots.Text = 'TakeSnapShots'

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 54
$System_Drawing_Point.Y = 259
$butTakeSnapshots.Location = $System_Drawing_Point
$butTakeSnapshots.DataBindings.DefaultDataSourceUpdateMode = 0
$butTakeSnapshots.add_Click($butTakeSnapshots_OnClick)

$form1.Controls.Add($butTakeSnapshots)

$rbServerList.TabIndex = 5
$rbServerList.Name = 'rbServerList'
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 104
$System_Drawing_Size.Height = 24
$rbServerList.Size = $System_Drawing_Size
$rbServerList.UseVisualStyleBackColor = $True

$rbServerList.Text = 'Load Server List'

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 137
$System_Drawing_Point.Y = 54
$rbServerList.Location = $System_Drawing_Point
$rbServerList.DataBindings.DefaultDataSourceUpdateMode = 0
$rbServerList.add_CheckedChanged($handler_rbServerList_CheckedChanged)

$form1.Controls.Add($rbServerList)

$rbTextInput.TabIndex = 4
$rbTextInput.Name = 'rbTextInput'
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 104
$System_Drawing_Size.Height = 24
$rbTextInput.Size = $System_Drawing_Size
$rbTextInput.UseVisualStyleBackColor = $True

$rbTextInput.Text = 'Text Input'
$rbTextInput.Checked = $True

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 55
$System_Drawing_Point.Y = 54
$rbTextInput.Location = $System_Drawing_Point
$rbTextInput.DataBindings.DefaultDataSourceUpdateMode = 0
$rbTextInput.TabStop = $True
$rbTextInput.add_CheckedChanged($handler_radioButton1_CheckedChanged)

$form1.Controls.Add($rbTextInput)

$lblPrefix.TabIndex = 3
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 100
$System_Drawing_Size.Height = 23
$lblPrefix.Size = $System_Drawing_Size
$lblPrefix.Text = 'Server Prefix'

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 30
$System_Drawing_Point.Y = 101
$lblPrefix.Location = $System_Drawing_Point
$lblPrefix.DataBindings.DefaultDataSourceUpdateMode = 0
$lblPrefix.Name = 'lblPrefix'

$form1.Controls.Add($lblPrefix)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 211
$System_Drawing_Size.Height = 20
$txtVMPrefix.Size = $System_Drawing_Size
$txtVMPrefix.DataBindings.DefaultDataSourceUpdateMode = 0
$txtVMPrefix.Name = 'txtVMPrefix'
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 30
$System_Drawing_Point.Y = 127
$txtVMPrefix.Location = $System_Drawing_Point
$txtVMPrefix.TabIndex = 2
$txtVMPrefix.add_TextChanged($handler_textBox2_TextChanged)

$form1.Controls.Add($txtVMPrefix)

$lblComments.TabIndex = 1
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 139
$System_Drawing_Size.Height = 23
$lblComments.Size = $System_Drawing_Size
$lblComments.Text = 'Snap Shot Comments'

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 30
$System_Drawing_Point.Y = 167
$lblComments.Location = $System_Drawing_Point
$lblComments.DataBindings.DefaultDataSourceUpdateMode = 0
$lblComments.Name = 'lblComments'
$lblComments.add_Click($handler_label1_Click)

$form1.Controls.Add($lblComments)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 211
$System_Drawing_Size.Height = 20
$txtComments.Size = $System_Drawing_Size
$txtComments.DataBindings.DefaultDataSourceUpdateMode = 0
$txtComments.Name = 'txtComments'
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 30
$System_Drawing_Point.Y = 193
$txtComments.Location = $System_Drawing_Point
$txtComments.TabIndex = 0

$form1.Controls.Add($txtComments)

$openFileDialog1.FileName = '*.txt'

#endregion Generated Form Code

#Show the Form
$form1.ShowDialog()| Out-Null

} #End Function

#Call the Function
GenerateForm