Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Obj_IntZone = New-Object -TypeName PSObject -Property @{
    DnsName = ""
    PcOu = ""
}

$Obj_DevZone = New-Object -TypeName PSObject -Property @{
    DnsName = ""
    PcOu = ""
}


$FormAdChange = New-Object system.Windows.Forms.Form
$FormAdChange.ClientSize = New-Object System.Drawing.Point(360,175)
$FormAdChange.FormBorderStyle = 'FixedDialog'
$FormAdChange.text = "PC 도메인 변경"
$FormAdChange.TopMost = $false

$L_ComName = New-Object system.Windows.Forms.Label
$L_ComName.text = "컴퓨터 이름"
$L_ComName.AutoSize = $true
$L_ComName.width = 25
$L_ComName.height = 10
$L_ComName.location = New-Object System.Drawing.Point(17,25)
$L_ComName.Font = New-Object System.Drawing.Font('Segoe UI',9)

$T_ComputeName = New-Object system.Windows.Forms.TextBox
$T_ComputeName.multiline = $false
$T_ComputeName.width = 160
$T_ComputeName.height = 20
$T_ComputeName.location = New-Object System.Drawing.Point(97,25)
$T_ComputeName.Font = New-Object System.Drawing.Font('Segoe UI',9)
$T_ComputeName.CharacterCasing = "Upper"

$L_OriginComputerName = New-Object system.Windows.Forms.Label
$L_OriginComputerName.text = "현 컴퓨터명"
$L_OriginComputerName.AutoSize = $true
$L_OriginComputerName.width = 25
$L_OriginComputerName.height = 10
$L_OriginComputerName.location = New-Object System.Drawing.Point(17,57)
$L_OriginComputerName.Font = New-Object System.Drawing.Font('Segoe UI',9)

$T_OriginName = New-Object system.Windows.Forms.TextBox
$T_OriginName.text = $env:computername
$T_OriginName.multiline = $false
$T_OriginName.width = 160
$T_OriginName.height = 35
$T_OriginName.location = New-Object System.Drawing.Point(97,57)
$T_OriginName.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#f3f2f1")
$T_OriginName.Font = New-Object System.Drawing.Font('Segoe UI',9)
$T_OriginName.Enabled = $false

$L_DomainZone = New-Object system.Windows.Forms.Label
$L_DomainZone.text = "도메인 정보"
$L_DomainZone.AutoSize = $true
$L_DomainZone.width = 25
$L_DomainZone.height = 10
$L_DomainZone.location = New-Object System.Drawing.Point(17,98)
$L_DomainZone.Font = New-Object System.Drawing.Font('Segoe UI',9)

$C_DomainZone = New-Object system.Windows.Forms.ComboBox
$C_DomainZone.text = ""
$C_DomainZone.width = 160
$C_DomainZone.height = 20
$C_DomainZone.location = New-Object System.Drawing.Point(97,98)
$C_DomainZone.Font = New-Object System.Drawing.Font('Segoe UI',9)
$C_DomainZone.DropDownStyle = "DropDownList"
$C_DomainZone.Items.Add('Azone') | out-null
$C_DomainZone.Items.Add('Bzone') | out-null


$L_OriginDomainName = New-Object system.Windows.Forms.Label
$L_OriginDomainName.text = "현 도메인명"
$L_OriginDomainName.AutoSize = $true
$L_OriginDomainName.width = 25
$L_OriginDomainName.height = 10
$L_OriginDomainName.location = New-Object System.Drawing.Point(17,130)
$L_OriginDomainName.Font = New-Object System.Drawing.Font('Segoe UI',9)

$T_OriginDomainName = New-Object system.Windows.Forms.TextBox
$T_OriginDomainName.text = $env:userdnsdomain
$T_OriginDomainName.multiline = $false
$T_OriginDomainName.width = 160
$T_OriginDomainName.height = 35
$T_OriginDomainName.location = New-Object System.Drawing.Point(97,130)
$T_OriginDomainName.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#f3f2f1")
$T_OriginDomainName.Font = New-Object System.Drawing.Font('Segoe UI',9)
$T_OriginDomainName.Enabled = $false

$B_Add = New-Object system.Windows.Forms.Button
$B_Add.text = "등록"
$B_Add.width = 63
$B_Add.height = 39
$B_Add.location = New-Object System.Drawing.Point(273,26)
$B_Add.Font = New-Object System.Drawing.Font('Segoe UI',9)

$B_Delete = New-Object system.Windows.Forms.Button
$B_Delete.text = "삭제"
$B_Delete.width = 63
$B_Delete.height = 39
$B_Delete.location = New-Object System.Drawing.Point(273,85)
$B_Delete.Font = New-Object System.Drawing.Font('Segoe UI',9)

$FormAdChange.controls.AddRange(@($T_ComputeName,$L_ComName,$L_DomainZone,$B_Add,$B_Delete,$C_DomainZone,$L_OriginDomainName,$T_OriginDomainName,$L_OriginComputerName,$T_OriginName))


#Write your logic code here


$B_Add.Add_Click({
    if ($env:userdnsdomain){
        [System.Windows.Forms.MessageBox]::Show("해당 컴퓨터는 도메인에 가입되어 있습니다. 재가입을 하려면 삭제 후 등록해주시기 바랍니다.", "정보")
    } else {  
        if ($T_ComputeName.Text -match '[A-Z]+[0-9]*'){
            $input = $T_ComputeName.Text.Trim()
            $cred = Get-Credential -Message "AD 관리자 계정 입력" 

            switch ($C_DomainZone.Text) {
                "" {
                    [System.Windows.Forms.MessageBox]::Show("가입할 도메인을 선택해주세요.", "정보")
                }
                "Azone" {
                    try {
                         
                        if ($input -eq $env:computername) {
                           
                            Add-Computer -ComputerName $input -DomainName $Obj_DevZone.DnsName -OUPath $Obj_DevZone.PcOu -Credential $cred -Restart -Force -ErrorAction stop
                        } else {
         
                            Add-Computer -NewName $input -DomainName $Obj_DevZone.DnsName -OUPath $Obj_DevZone.PcOu -Credential $cred -Restart -Force -ErrorAction stop
                        }
                    } catch {
                        [System.Windows.Forms.MessageBox]::Show("$_" , "정보")
                    }
                }
                "Bzone" {
                    try {
                        if ($input -eq $env:computername) {
                            Add-Computer -ComputerName $input -DomainName $Obj_IntZone.DnsName -OUPath $Obj_IntZone.PcOu -Credential $cred -Restart -Force -ErrorAction stop
                        } else {
                            Add-Computer -NewName $input -DomainName $Obj_IntZone.DnsName -OUPath $Obj_IntZone.PcOu -Credential $cred -Restart -Force -ErrorAction stop
                        }
                    }
                    catch {
                         [System.Windows.Forms.MessageBox]::Show("$_" , "정보")
                    }
                }  
          }


        } else {
            [System.Windows.Forms.MessageBox]::Show("컴퓨터 이름을 영문과 숫자로 입력해주세요.", "정보")
        } 
    }
})


$B_Delete.Add_Click({ 
    try {
        $result = [System.Windows.Forms.MessageBox]::Show('정말로 삭제 하시겠습니까? 삭제 시 자동으로 PC가 리부팅 됩니다' , "경고" , 4)
        if ($result -eq 'Yes') {
            Remove-computer -Restart -Force -ErrorAction stop 
        } 
    } catch {
         [System.Windows.Forms.MessageBox]::Show("$_" , "정보") 
    }
})

[void]$FormAdChange.ShowDialog()