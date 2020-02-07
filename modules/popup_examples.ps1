function popUp($text,$title) {
 $a = new-object -comobject wscript.shell
 $b = $a.popup($text,0,$title,0)
}
[void][reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
Add-Type - AssemblyName Microsoft.VisualBasic
#input and popup example
$user = [Microsoft.VisualBasic.Interaction]::InputBox('Enter a user name', 'User', "$env:UserName")
popUp $user "You Entered"


# Introduction to Radio buttons and Grouping #
##############################################
 
# A function to create the form 
function Cheesy_Form{
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
    
    # Set the size of your form
    $Form = New-Object System.Windows.Forms.Form
    $Form.width = 500
    $Form.height = 300
    $Form.Text = ”My Cheesy Form with Radio buttons"
 
    # Set the font of the text to be used within the form
    $Font = New-Object System.Drawing.Font("Times New Roman",12)
    $Form.Font = $Font
 
    # Create a group that will contain your radio buttons
    $MyGroupBox = New-Object System.Windows.Forms.GroupBox
    $MyGroupBox.Location = '40,30'
    $MyGroupBox.size = '400,150'
    $MyGroupBox.text = "Do you like Cheese?"
    
    # Create the collection of radio buttons
    $RadioButton1 = New-Object System.Windows.Forms.RadioButton
    $RadioButton1.Location = '20,40'
    $RadioButton1.size = '350,20'
    $RadioButton1.Checked = $true 
    $RadioButton1.Text = "Yes - I like Cheese."
 
    $RadioButton2 = New-Object System.Windows.Forms.RadioButton
    $RadioButton2.Location = '20,70'
    $RadioButton2.size = '350,20'
    $RadioButton2.Checked = $false
    $RadioButton2.Text = "No - I don't like Cheese."
 
    $RadioButton3 = New-Object System.Windows.Forms.RadioButton
    $RadioButton3.Location = '20,100'
    $RadioButton3.size = '350,20'
    $RadioButton3.Checked = $false
    $RadioButton3.Text = "Sometimes - Depending on the type of cheese."
 
    # Add an OK button
    # Thanks to J.Vierra for simplifing the use of buttons in forms
    $OKButton = new-object System.Windows.Forms.Button
    $OKButton.Location = '130,200'
    $OKButton.Size = '100,40' 
    $OKButton.Text = 'OK'
    $OKButton.DialogResult=[System.Windows.Forms.DialogResult]::OK
 
    #Add a cancel button
    $CancelButton = new-object System.Windows.Forms.Button
    $CancelButton.Location = '255,200'
    $CancelButton.Size = '100,40'
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult=[System.Windows.Forms.DialogResult]::Cancel
 
    # Add all the Form controls on one line 
    $form.Controls.AddRange(@($MyGroupBox,$OKButton,$CancelButton))
 
    # Add all the GroupBox controls on one line
    $MyGroupBox.Controls.AddRange(@($Radiobutton1,$RadioButton2,$RadioButton3))
    
    # Assign the Accept and Cancel options in the form to the corresponding buttons
    $form.AcceptButton = $OKButton
    $form.CancelButton = $CancelButton
 
    # Activate the form
    $form.Add_Shown({$form.Activate()})    
    
    # Get the results from the button click
    $dialogResult = $form.ShowDialog()
 
    # If the OK button is selected
    if ($dialogResult -eq "OK"){
        
        # Check the current state of each radio button and respond accordingly
        if ($RadioButton1.Checked){
           [System.Windows.Forms.MessageBox]::Show("You like cheese." , "Great")}
        elseif ($RadioButton2.Checked){
              [System.Windows.Forms.MessageBox]::Show("So your not a fan of cheese." , "Awe")}
        elseif ($RadioButton3.Checked = $true){[System.Windows.Forms.MessageBox]::Show("That's OK - some cheeses have a strong taste" , "On the fence")}
    }
}
 
# Call the function
Cheesy_Form



#variable set to exe path Octopus.Action.Terraform.CustomTerraformExecutable
#see https://octopus.com/docs/deployment-examples/terraform-deployments/apply-terraform#special-variables
