Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Yönetici Yetkisi Kontrolü ---
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# --- Ana Form ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Kolay Ağ Yedekleme Asistanı (Robocopy)"
$form.Size = New-Object System.Drawing.Size(580, 750) # Buton için boyutu biraz daha artırdık
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(245, 247, 250)

# --- Fontlar ---
$fontLabel = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$fontButton = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$fontInput = New-Object System.Drawing.Font("Segoe UI", 10)

# --- Yönetici Değilse Üst Uyarı Bandı ---
if (-not $isAdmin) {
    $lblAdminWarning = New-Object System.Windows.Forms.Label
    $lblAdminWarning.Text = "⚠️ UYARI: Standart kullanıcı modundasınız. Zamanlanmış görev eklemek için yönetici yetkisi gereklidir!"
    $lblAdminWarning.Dock = [System.Windows.Forms.DockStyle]::Top
    $lblAdminWarning.Height = 30
    $lblAdminWarning.BackColor = [System.Drawing.Color]::MistyRose
    $lblAdminWarning.ForeColor = [System.Drawing.Color]::DarkRed
    $lblAdminWarning.Font = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Bold)
    $lblAdminWarning.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $form.Controls.Add($lblAdminWarning)
}

# ================== TOOLTIP (AÇIKLAMA BALONCUKLARI) ==================
$toolTip = New-Object System.Windows.Forms.ToolTip
$toolTip.AutoPopDelay = 10000
$toolTip.InitialDelay = 500
$toolTip.ReshowDelay = 200
$toolTip.ShowAlways = $true

# --- Tab Kontrolü Boşluk Hesabı ---
$yOffset = if (-not $isAdmin) { 40 } else { 10 }

# --- Tab Kontrolü ---
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Location = New-Object System.Drawing.Point(10, $yOffset)
$tabControl.Size = New-Object System.Drawing.Size(540, 470)
$tabControl.Font = $fontLabel
$form.Controls.Add($tabControl)

# --- Sekmeler ---
$tab1 = New-Object System.Windows.Forms.TabPage
$tab1.Text = "Temel Ayarlar"
$tab1.BackColor = [System.Drawing.Color]::FromArgb(245, 247, 250)
$tabControl.Controls.Add($tab1)

$tab2 = New-Object System.Windows.Forms.TabPage
$tab2.Text = "Gelişmiş Seçenekler"
$tab2.BackColor = [System.Drawing.Color]::FromArgb(245, 247, 250)
$tabControl.Controls.Add($tab2)

# ================== TEMEL AYARLAR ==================
$lblKaynak = New-Object System.Windows.Forms.Label
$lblKaynak.Text = "Kopyalanacak Kaynak Klasör (PC):"
$lblKaynak.Location = New-Object System.Drawing.Point(20, 20)
$lblKaynak.Size = New-Object System.Drawing.Size(400, 25)
$lblKaynak.Font = $fontLabel
$tab1.Controls.Add($lblKaynak)

$txtKaynak = New-Object System.Windows.Forms.TextBox
$txtKaynak.Location = New-Object System.Drawing.Point(20, 45)
$txtKaynak.Size = New-Object System.Drawing.Size(370, 25)
$txtKaynak.Font = $fontInput
$tab1.Controls.Add($txtKaynak)

$btnKaynakSec = New-Object System.Windows.Forms.Button
$btnKaynakSec.Text = "Seç..."
$btnKaynakSec.Location = New-Object System.Drawing.Point(400, 44)
$btnKaynakSec.Size = New-Object System.Drawing.Size(80, 28)
$btnKaynakSec.Font = $fontButton
$btnKaynakSec.BackColor = [System.Drawing.Color]::LightGray
$btnKaynakSec.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $txtKaynak.Text = $folderBrowser.SelectedPath
    }
})
$tab1.Controls.Add($btnKaynakSec)
$toolTip.SetToolTip($btnKaynakSec, "Bilgisayarınızdaki yedeklemek istediğiniz kaynak klasörü seçin.")

$lblHedef = New-Object System.Windows.Forms.Label
$lblHedef.Text = "Yedeklenecek Hedef Klasör (Ağ / NAS Sürücüsü):"
$lblHedef.Location = New-Object System.Drawing.Point(20, 95)
$lblHedef.Size = New-Object System.Drawing.Size(400, 25)
$lblHedef.Font = $fontLabel
$tab1.Controls.Add($lblHedef)

$txtHedef = New-Object System.Windows.Forms.TextBox
$txtHedef.Location = New-Object System.Drawing.Point(20, 120)
$txtHedef.Size = New-Object System.Drawing.Size(370, 25)
$txtHedef.Font = $fontInput
$txtHedef.Text = "\\192.168.1.100\Yedek"
$tab1.Controls.Add($txtHedef)

$btnHedefSec = New-Object System.Windows.Forms.Button
$btnHedefSec.Text = "Seç..."
$btnHedefSec.Location = New-Object System.Drawing.Point(400, 119)
$btnHedefSec.Size = New-Object System.Drawing.Size(80, 28)
$btnHedefSec.Font = $fontButton
$btnHedefSec.BackColor = [System.Drawing.Color]::LightGray
$btnHedefSec.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $txtHedef.Text = $folderBrowser.SelectedPath
    }
})
$tab1.Controls.Add($btnHedefSec)
$toolTip.SetToolTip($btnHedefSec, "Yedeklerin aktarılacağı hedef klasörü, yerel veya ağ (UNC) yolunu seçin.")

# Kopyalama Modu
$grpMod = New-Object System.Windows.Forms.GroupBox
$grpMod.Text = "Kopyalama Modu"
$grpMod.Location = New-Object System.Drawing.Point(20, 170)
$grpMod.Size = New-Object System.Drawing.Size(480, 130)
$grpMod.Font = $fontLabel
$tab1.Controls.Add($grpMod)

$radioNone = New-Object System.Windows.Forms.RadioButton
$radioNone.Text = "Yalnızca üst klasördeki dosyalar (alt klasörler kopyalanmaz)"
$radioNone.Location = New-Object System.Drawing.Point(15, 25)
$radioNone.Size = New-Object System.Drawing.Size(450, 20)
$radioNone.Font = $fontInput
$grpMod.Controls.Add($radioNone)
$toolTip.SetToolTip($radioNone, "Sadece seçtiğiniz ana klasörün içindeki dosyaları kopyalar. Alt klasörleri tamamen yok sayar.")

$radioS = New-Object System.Windows.Forms.RadioButton
$radioS.Text = "Alt klasörleriyle birlikte (boş klasörler hariç) (/S)"
$radioS.Location = New-Object System.Drawing.Point(15, 50)
$radioS.Size = New-Object System.Drawing.Size(450, 20)
$radioS.Font = $fontInput
$grpMod.Controls.Add($radioS)
$toolTip.SetToolTip($radioS, "/S: Alt klasörleri ve içlerindeki dosyaları kopyalar, ancak içi tamamen boş olan klasörleri hedefte oluşturmaz.")

$radioE = New-Object System.Windows.Forms.RadioButton
$radioE.Text = "Alt klasörleriyle birlikte, boş klasörler dahil (/E)"
$radioE.Location = New-Object System.Drawing.Point(15, 75)
$radioE.Size = New-Object System.Drawing.Size(450, 20)
$radioE.Font = $fontInput
$radioE.Checked = $true
$grpMod.Controls.Add($radioE)
$toolTip.SetToolTip($radioE, "/E: Alt klasörlerin tamamını kopyalar. İçi boş olsa dahi tüm klasör yapısını hedefte aynen oluşturur.")

$radioMIR = New-Object System.Windows.Forms.RadioButton
$radioMIR.Text = "Ayna modu - hedefte fazladan dosya/klasör varsa siler (/MIR)"
$radioMIR.Location = New-Object System.Drawing.Point(15, 100)
$radioMIR.Size = New-Object System.Drawing.Size(450, 20)
$radioMIR.Font = $fontInput
$grpMod.Controls.Add($radioMIR)
$toolTip.SetToolTip($radioMIR, "/MIR (Mirror): Kaynak ile hedefi birebir eşitler. Kaynakta silinmiş bir dosya hedefte hala varsa, hedeftekini de siler! Dikkatli kullanın.")

# Diğer Temel Seçenekler
$chkZ = New-Object System.Windows.Forms.CheckBox
$chkZ.Text = "Yeniden başlatılabilir mod (/Z)"
$chkZ.Location = New-Object System.Drawing.Point(20, 315)
$chkZ.Size = New-Object System.Drawing.Size(230, 20)
$chkZ.Font = $fontInput
$chkZ.Checked = $true
$tab1.Controls.Add($chkZ)
$toolTip.SetToolTip($chkZ, "/Z: Ağ bağlantısı kesilirse, dosya kopyalamasını kaldığı yerden devam ettirir. Büyük dosyalar için can kurtarır.")

$chkB = New-Object System.Windows.Forms.CheckBox
$chkB.Text = "Yedekleme modu (/B)"
$chkB.Location = New-Object System.Drawing.Point(260, 315)
$chkB.Size = New-Object System.Drawing.Size(200, 20)
$chkB.Font = $fontInput
$tab1.Controls.Add($chkB)
$toolTip.SetToolTip($chkB, "/B: Yönetici (Administrator) yetkisiyle çalışarak, dosya izinlerinden (ACL) bağımsız olarak erişim kısıtlamalı dosyaları kopyalamayı sağlar.")

$chkNP = New-Object System.Windows.Forms.CheckBox
$chkNP.Text = "İlerleme göstergesini gizle (/NP)"
$chkNP.Location = New-Object System.Drawing.Point(20, 340)
$chkNP.Size = New-Object System.Drawing.Size(230, 20)
$chkNP.Font = $fontInput
$chkNP.Checked = $true
$tab1.Controls.Add($chkNP)
$toolTip.SetToolTip($chkNP, "/NP: Konsol ekranında kopyalama yüzdesinin (%0... %100) sürekli yazılmasını engeller. Günlük dosyası boyutunu küçük tutmak ve hızı artırmak için önerilir.")

$chkTBD = New-Object System.Windows.Forms.CheckBox
$chkTBD.Text = "Paylaşım adı tanımlanana kadar bekle (/TBD)"
$chkTBD.Location = New-Object System.Drawing.Point(260, 340)
$chkTBD.Size = New-Object System.Drawing.Size(250, 20)
$chkTBD.Font = $fontInput
$chkTBD.Checked = $true
$tab1.Controls.Add($chkTBD)
$toolTip.SetToolTip($chkTBD, "/TBD (To Be Defined): Ağ paylaşım adı henüz hazır değilse hata verip çıkmak yerine, ağ yolunun aktifleşmesini sabırla bekler.")

# Günlük Kaydı
$chkLog = New-Object System.Windows.Forms.CheckBox
$chkLog.Text = "Günlük dosyasına yaz"
$chkLog.Location = New-Object System.Drawing.Point(20, 375)
$chkLog.Size = New-Object System.Drawing.Size(150, 20)
$chkLog.Font = $fontInput
$tab1.Controls.Add($chkLog)
$toolTip.SetToolTip($chkLog, "Kopyalama sonuçlarını, detaylarını ve hatalarını bir metin dosyasına (.log) kaydetmek için aktifleştirin.")

$txtLogPath = New-Object System.Windows.Forms.TextBox
$txtLogPath.Location = New-Object System.Drawing.Point(20, 400)
$txtLogPath.Size = New-Object System.Drawing.Size(300, 25)
$txtLogPath.Font = $fontInput
$txtLogPath.Enabled = $false
$tab1.Controls.Add($txtLogPath)

$btnLogSec = New-Object System.Windows.Forms.Button
$btnLogSec.Text = "Seç..."
$btnLogSec.Location = New-Object System.Drawing.Point(330, 399)
$btnLogSec.Size = New-Object System.Drawing.Size(80, 28)
$btnLogSec.Font = $fontButton
$btnLogSec.BackColor = [System.Drawing.Color]::LightGray
$btnLogSec.Enabled = $false
$btnLogSec.Add_Click({
    $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveDialog.Filter = "Günlük dosyaları (*.log)|*.log|Tüm dosyalar (*.*)|*.*"
    if ($saveDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $txtLogPath.Text = $saveDialog.FileName
    }
})
$tab1.Controls.Add($btnLogSec)
$toolTip.SetToolTip($btnLogSec, "Günlük (.log) dosyasının kaydedileceği konumu ve dosya adını belirleyin.")

$chkLog.Add_CheckedChanged({
    $txtLogPath.Enabled = $chkLog.Checked
    $btnLogSec.Enabled = $chkLog.Checked
    Update-PreviewIfReady
})

# ================== GELİŞMİŞ AYARLAR ==================
$grpRetry = New-Object System.Windows.Forms.GroupBox
$grpRetry.Text = "Yeniden Deneme Ayarları"
$grpRetry.Location = New-Object System.Drawing.Point(20, 20)
$grpRetry.Size = New-Object System.Drawing.Size(480, 80)
$grpRetry.Font = $fontLabel
$tab2.Controls.Add($grpRetry)

$lblR = New-Object System.Windows.Forms.Label
$lblR.Text = "Deneme sayısı (/R):"
$lblR.Location = New-Object System.Drawing.Point(15, 30)
$lblR.Size = New-Object System.Drawing.Size(130, 20)
$lblR.Font = $fontInput
$grpRetry.Controls.Add($lblR)

$numR = New-Object System.Windows.Forms.NumericUpDown
$numR.Location = New-Object System.Drawing.Point(150, 28)
$numR.Size = New-Object System.Drawing.Size(60, 25)
$numR.Font = $fontInput
$numR.Minimum = 0
$numR.Maximum = 100
$numR.Value = 5
$grpRetry.Controls.Add($numR)
$toolTip.SetToolTip($numR, "/R (Retry): Bir dosya kopyalanamadığında işlemin kaç kez yeniden deneneceğini belirtir. (Önerilen: 5)")

$lblW = New-Object System.Windows.Forms.Label
$lblW.Text = "Bekleme süresi (/W, sn):"
$lblW.Location = New-Object System.Drawing.Point(230, 30)
$lblW.Size = New-Object System.Drawing.Size(130, 20)
$lblW.Font = $fontInput
$grpRetry.Controls.Add($lblW)

$numW = New-Object System.Windows.Forms.NumericUpDown
$numW.Location = New-Object System.Drawing.Point(370, 28)
$numW.Size = New-Object System.Drawing.Size(60, 25)
$numW.Font = $fontInput
$numW.Minimum = 0
$numW.Maximum = 3600
$numW.Value = 5
$grpRetry.Controls.Add($numW)
$toolTip.SetToolTip($numW, "/W (Wait): Yeniden denemeler arasında kaç saniye bekleneceğini belirler.")

# Çoklu İş Parçacığı
$grpMT = New-Object System.Windows.Forms.GroupBox
$grpMT.Text = "Çoklu İş Parçacığı"
$grpMT.Location = New-Object System.Drawing.Point(20, 120)
$grpMT.Size = New-Object System.Drawing.Size(480, 60)
$grpMT.Font = $fontLabel
$tab2.Controls.Add($grpMT)

$chkMT = New-Object System.Windows.Forms.CheckBox
$chkMT.Text = "/MT kullan"
$chkMT.Location = New-Object System.Drawing.Point(15, 22)
$chkMT.Size = New-Object System.Drawing.Size(100, 20)
$chkMT.Font = $fontInput
$grpMT.Controls.Add($chkMT)
$toolTip.SetToolTip($chkMT, "/MT (Multi-Threaded): Dosyaları birden fazla iş parçacığı kullanarak eşzamanlı kopyalar. Özellikle ağ üzerinde hızı muazzam artırır.")

$numMT = New-Object System.Windows.Forms.NumericUpDown
$numMT.Location = New-Object System.Drawing.Point(120, 20)
$numMT.Size = New-Object System.Drawing.Size(60, 25)
$numMT.Font = $fontInput
$numMT.Minimum = 1
$numMT.Maximum = 128
$numMT.Value = 8
$numMT.Enabled = $false
$grpMT.Controls.Add($numMT)
$toolTip.SetToolTip($numMT, "Kullanılacak eşzamanlı kanal sayısı (1 ile 128 arası). Çok yüksek değerler sistemi yorabilir, 8 veya 16 idealdir.")

$chkMT.Add_CheckedChanged({
    $numMT.Enabled = $chkMT.Checked
    Update-PreviewIfReady
})

# Kopyalama Bayrakları
$grpCopyFlags = New-Object System.Windows.Forms.GroupBox
$grpCopyFlags.Text = "Kopyalama Bayrakları (/COPY)"
$grpCopyFlags.Location = New-Object System.Drawing.Point(20, 200)
$grpCopyFlags.Size = New-Object System.Drawing.Size(480, 110)
$grpCopyFlags.Font = $fontLabel
$tab2.Controls.Add($grpCopyFlags)

$chkD = New-Object System.Windows.Forms.CheckBox
$chkD.Text = "Veri (D)"
$chkD.Location = New-Object System.Drawing.Point(15, 25)
$chkD.Size = New-Object System.Drawing.Size(80, 20)
$chkD.Font = $fontInput
$chkD.Checked = $true
$grpCopyFlags.Controls.Add($chkD)
$toolTip.SetToolTip($chkD, "Dosyanın asıl içeriğini (Data) kopyalar. (Zorunludur)")

$chkA = New-Object System.Windows.Forms.CheckBox
$chkA.Text = "Öznitelik (A)"
$chkA.Location = New-Object System.Drawing.Point(105, 25)
$chkA.Size = New-Object System.Drawing.Size(110, 20)
$chkA.Font = $fontInput
$chkA.Checked = $true
$grpCopyFlags.Controls.Add($chkA)
$toolTip.SetToolTip($chkA, "Dosya özniteliklerini (Salt Okunur, Gizli vb.) kopyalar.")

$chkT = New-Object System.Windows.Forms.CheckBox
$chkT.Text = "Zaman Damgası (T)"
$chkT.Location = New-Object System.Drawing.Point(225, 25)
$chkT.Size = New-Object System.Drawing.Size(130, 20)
$chkT.Font = $fontInput
$chkT.Checked = $true
$grpCopyFlags.Controls.Add($chkT)
$toolTip.SetToolTip($chkT, "Oluşturulma, değiştirilme ve son erişim tarihlerini aynen korur.")

$chkS = New-Object System.Windows.Forms.CheckBox
$chkS.Text = "Güvenlik (S)"
$chkS.Location = New-Object System.Drawing.Point(365, 25)
$chkS.Size = New-Object System.Drawing.Size(100, 20)
$chkS.Font = $fontInput
$grpCopyFlags.Controls.Add($chkS)
$toolTip.SetToolTip($chkS, "NTFS erişim izinlerini (ACL - Access Control List) kopyalar.")

$chkO = New-Object System.Windows.Forms.CheckBox
$chkO.Text = "Sahip (O)"
$chkO.Location = New-Object System.Drawing.Point(15, 50)
$chkO.Size = New-Object System.Drawing.Size(90, 20)
$chkO.Font = $fontInput
$grpCopyFlags.Controls.Add($chkO)
$toolTip.SetToolTip($chkO, "Dosya sahibi (Owner) bilgisini koruyarak kopyalar.")

$chkU = New-Object System.Windows.Forms.CheckBox
$chkU.Text = "Denetim (U)"
$chkU.Location = New-Object System.Drawing.Point(115, 50)
$chkU.Size = New-Object System.Drawing.Size(100, 20)
$chkU.Font = $fontInput
$grpCopyFlags.Controls.Add($chkU)
$toolTip.SetToolTip($chkU, "Dosya denetleme (Auditing) bilgilerini kopyalar.")

$chkDCOPYT = New-Object System.Windows.Forms.CheckBox
$chkDCOPYT.Text = "/DCOPY:T (Klasör zaman damgalarını kopyala)"
$chkDCOPYT.Location = New-Object System.Drawing.Point(15, 78)
$chkDCOPYT.Size = New-Object System.Drawing.Size(300, 20)
$chkDCOPYT.Font = $fontInput
$grpCopyFlags.Controls.Add($chkDCOPYT)
$toolTip.SetToolTip($chkDCOPYT, "/DCOPY:T: Kopyalanan klasörlerin de oluşturulma ve değiştirilme tarihlerini korur.")

# Hariç Tutmalar
$grpExclude = New-Object System.Windows.Forms.GroupBox
$grpExclude.Text = "Hariç Tutmalar"
$grpExclude.Location = New-Object System.Drawing.Point(20, 330)
$grpExclude.Size = New-Object System.Drawing.Size(480, 110)
$grpExclude.Font = $fontLabel
$tab2.Controls.Add($grpExclude)

$lblExcDir = New-Object System.Windows.Forms.Label
$lblExcDir.Text = "Hariç klasörler (boşlukla ayırın):"
$lblExcDir.Location = New-Object System.Drawing.Point(15, 25)
$lblExcDir.Size = New-Object System.Drawing.Size(250, 20)
$lblExcDir.Font = $fontInput
$grpExclude.Controls.Add($lblExcDir)

$txtExcludeDirs = New-Object System.Windows.Forms.TextBox
$txtExcludeDirs.Location = New-Object System.Drawing.Point(15, 45)
$txtExcludeDirs.Size = New-Object System.Drawing.Size(210, 25)
$txtExcludeDirs.Font = $fontInput
$grpExclude.Controls.Add($txtExcludeDirs)
$toolTip.SetToolTip($txtExcludeDirs, "/XD: Yedeklenmesini istemediğiniz klasör adları (Örn: Temp Cache)")

$lblExcFile = New-Object System.Windows.Forms.Label
$lblExcFile.Text = "Hariç dosyalar (boşlukla ayırın):"
$lblExcFile.Location = New-Object System.Drawing.Point(245, 25)
$lblExcFile.Size = New-Object System.Drawing.Size(220, 20)
$lblExcFile.Font = $fontInput
$grpExclude.Controls.Add($lblExcFile)

$txtExcludeFiles = New-Object System.Windows.Forms.TextBox
$txtExcludeFiles.Location = New-Object System.Drawing.Point(245, 45)
$txtExcludeFiles.Size = New-Object System.Drawing.Size(210, 25)
$txtExcludeFiles.Font = $fontInput
$grpExclude.Controls.Add($txtExcludeFiles)
$toolTip.SetToolTip($txtExcludeFiles, "/XF: Yedeklenmesini istemediğiniz dosya veya uzantılar (Örn: *.tmp *.lnk)")

# ================== KOMUT ÖNİZLEME ==================
$lblKod = New-Object System.Windows.Forms.Label
$lblKod.Text = "Oluşturulan Robocopy Komutu:"
$lblKod.Location = New-Object System.Drawing.Point(20, 520)
$lblKod.Size = New-Object System.Drawing.Size(400, 25)
$lblKod.Font = $fontLabel
$form.Controls.Add($lblKod)

$txtKodOnizleme = New-Object System.Windows.Forms.TextBox
$txtKodOnizleme.Multiline = $true
$txtKodOnizleme.ReadOnly = $true
$txtKodOnizleme.Location = New-Object System.Drawing.Point(20, 545)
$txtKodOnizleme.Size = New-Object System.Drawing.Size(520, 70)
$txtKodOnizleme.Font = New-Object System.Drawing.Font("Consolas", 9.5)
$txtKodOnizleme.BackColor = [System.Drawing.Color]::Black
$txtKodOnizleme.ForeColor = [System.Drawing.Color]::LimeGreen
$txtKodOnizleme.Text = "Lütfen yukarıdan klasörleri seçin..."
$form.Controls.Add($txtKodOnizleme)

# ================== YEDEKLEME BUTONU ==================
$btnYedekle = New-Object System.Windows.Forms.Button
$btnYedekle.Text = "YEDEKLEMEYİ ŞİMDİ BAŞLAT"
$btnYedekle.Location = New-Object System.Drawing.Point(20, 625)
$btnYedekle.Size = New-Object System.Drawing.Size(250, 45) # Boyutları yan yana butonlar için yarıya düşürdük
$btnYedekle.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$btnYedekle.BackColor = [System.Drawing.Color]::FromArgb(46, 204, 113)
$btnYedekle.ForeColor = [System.Drawing.Color]::White
$btnYedekle.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnYedekle.Add_Click({
    if (-not $txtKaynak.Text -or -not $txtHedef.Text) {
        [System.Windows.Forms.MessageBox]::Show("Lütfen hem kaynak hem de hedef klasörleri seçin!", "Hata", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }

    $btnYedekle.Enabled = $false
    $btnYedekle.Text = "Kopyalanıyor..."
    $btnYedekle.BackColor = [System.Drawing.Color]::Orange

    $action = {
        param($cmdArgs)
        $argsOnly = $cmdArgs -replace '^robocopy\s+', ''
        Start-Process cmd.exe -ArgumentList "/c robocopy $argsOnly" -NoNewWindow -Wait
    }

    $robocopyCmd = Get-RobocopyArgs
    if ($robocopyCmd) {
        $ps = [PowerShell]::Create().AddScript($action).AddArgument($robocopyCmd)
        $asyncResult = $ps.BeginInvoke()

        while (-not $asyncResult.IsCompleted) {
            [System.Windows.Forms.Application]::DoEvents()
            Start-Sleep -Milliseconds 100
        }

        try {
            $ps.EndInvoke($asyncResult)
            [System.Windows.Forms.MessageBox]::Show("Yedekleme işlemi başarıyla tamamlandı!", "Başarılı", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Bir hata oluştu:`n$($_.Exception.Message)", "Hata", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
        finally {
            $ps.Dispose()
            $btnYedekle.Enabled = $true
            $btnYedekle.Text = "YEDEKLEMEYİ ŞİMDİ BAŞLAT"
            $btnYedekle.BackColor = [System.Drawing.Color]::FromArgb(46, 204, 113)
        }
    }
})
$form.Controls.Add($btnYedekle)

# ================== GÖREV EKLEME BUTONU ==================
$btnGorevEkle = New-Object System.Windows.Forms.Button
$btnGorevEkle.Text = "GÖREV ZAMANLAYICIYA EKLE"
$btnGorevEkle.Location = New-Object System.Drawing.Point(290, 625)
$btnGorevEkle.Size = New-Object System.Drawing.Size(250, 45)
$btnGorevEkle.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$btnGorevEkle.BackColor = [System.Drawing.Color]::FromArgb(52, 152, 219)
$btnGorevEkle.ForeColor = [System.Drawing.Color]::White
$btnGorevEkle.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$toolTip.SetToolTip($btnGorevEkle, "Belirttiğiniz robocopy komutunu her gün otomatik çalışacak şekilde Windows Görev Zamanlayıcısına ekler.")

$btnGorevEkle.Add_Click({
    if (-not $isAdmin) {
        [System.Windows.Forms.MessageBox]::Show("Zamanlanmış görev oluşturmak için bu scripti 'Yönetici Olarak Çalıştır' modunda başlatmalısınız!", "Yetki Hatası", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    if (-not $txtKaynak.Text -or -not $txtHedef.Text) {
        [System.Windows.Forms.MessageBox]::Show("Lütfen görev oluşturmadan önce kaynak ve hedef yollarını belirleyin!", "Hata", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }

    # Kullanıcıdan her gün hangi saatte çalışacağını soralım
    $saatInput = [Microsoft.VisualBasic.Interaction]::InputBox("Görevin her gün saat kaçta çalışmasını istersiniz? (Örn: 23:00 veya 03:30)", "Görev Saati Belirleyin", "23:00")
    if (-not $saatInput) { return } # İptal edilirse çık

    # Saat formatı kontrolü
    if (-not ($saatInput -match "^\d{2}:\d{2}$")) {
        [System.Windows.Forms.MessageBox]::Show("Geçersiz saat formatı! Lütfen HH:MM formatında girin. Örn: 23:00", "Format Hatası", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    try {
        # Adım 1: Klasör ve .bat dosyasını hazırlama
        $klasorYolu = "C:\Yedekleme_Gorevleri"
        if (-not (Test-Path $klasorYolu)) {
            New-Item -ItemType Directory -Force -Path $klasorYolu | Out-Null
        }

        # Benzersiz bir görev ve dosya ismi üretelim (Kaynak ve hedefin karmaşasını önlemek adına)
        $cleanKaynak = ($txtKaynak.Text -replace '[^a-zA-Z0-9]', '_').Trim('_')
        $batDosyaAdi = "YedekGorevi_$cleanKaynak.bat"
        $batFullYol = Join-Path $klasorYolu $batDosyaAdi
        $gorevAdi = "Oto_Yedek_$cleanKaynak"

        # Robocopy kodunu UTF-8 (BOM'suz veya standart ANSI) olarak .bat dosyasına yazalım
        $robocopyCmd = Get-RobocopyArgs
        $batIcerik = "@echo off`r`necho Yedekleme baslatildi: %date% %time%`r`n$robocopyCmd`r`necho Yedekleme bitti: %date% %time%"
        [System.IO.File]::WriteAllText($batFullYol, $batIcerik, [System.Text.Encoding]::Default)

        # Adım 2: Windows Görev Zamanlayıcısına Görev Ekleme (Task Scheduler)
        $action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"$batFullYol`""
        $trigger = New-ScheduledTaskTrigger -Daily -At $saatInput
        $principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

        # Eğer eski bir görev varsa çakışmayı önlemek için önce silelim
        if (Get-ScheduledTask -TaskName $gorevAdi -ErrorAction SilentlyContinue) {
            Unregister-ScheduledTask -TaskName $gorevAdi -Confirm:$false | Out-Null
        }

        # Görevi kaydet
        Register-ScheduledTask -TaskName $gorevAdi -Action $action -Trigger $trigger -Principal $principal | Out-Null

        [System.Windows.Forms.MessageBox]::Show("Zamanlanmış görev başarıyla oluşturuldu!`n`nGörev Adı: $gorevAdi`nHatırlatıcı: Her gün saat $saatInput`nÇalıştırılacak Dosya: $batFullYol`n`nGörev sistem seviyesinde (SYSTEM) arka planda sessizce çalışacaktır.", "Görev Eklendi", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Görev eklenirken bir hata oluştu:`n$($_.Exception.Message)", "Hata", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})
$form.Controls.Add($btnGorevEkle)

# ================== ROBOKOPY KOMUTUNU OLUŞTURAN FONKSİYON ==================
function Get-RobocopyArgs {
    $source = $txtKaynak.Text.Trim().Trim('"')
    $dest   = $txtHedef.Text.Trim().Trim('"')
    if (-not $source -or -not $dest) { return "" }

    $argsList = @()
    $argsList += "`"$source`""
    $argsList += "`"$dest`""

    if ($radioE.Checked)        { $argsList += "/E" }
    elseif ($radioS.Checked)    { $argsList += "/S" }
    elseif ($radioMIR.Checked)  { $argsList += "/MIR" }

    if ($chkZ.Checked)   { $argsList += "/Z" }
    if ($chkB.Checked)   { $argsList += "/B" }
    if ($chkNP.Checked)  { $argsList += "/NP" }
    if ($chkTBD.Checked) { $argsList += "/TBD" }

    $argsList += "/R:$($numR.Value)"
    $argsList += "/W:$($numW.Value)"

    if ($chkMT.Checked) { $argsList += "/MT:$($numMT.Value)" }

    $copyFlags = ""
    if ($chkD.Checked) { $copyFlags += "D" }
    if ($chkA.Checked) { $copyFlags += "A" }
    if ($chkT.Checked) { $copyFlags += "T" }
    if ($chkS.Checked) { $copyFlags += "S" }
    if ($chkO.Checked) { $copyFlags += "O" }
    if ($chkU.Checked) { $copyFlags += "U" }
    if ($copyFlags -ne "") { $argsList += "/COPY:$copyFlags" }

    if ($chkDCOPYT.Checked) { $argsList += "/DCOPY:T" }

    if ($chkLog.Checked -and $txtLogPath.Text.Trim() -ne "") {
        $logPath = $txtLogPath.Text.Trim().Trim('"')
        $argsList += "/LOG:`"$logPath`""
    }

    $excludeDirs = $txtExcludeDirs.Text.Trim()
    if ($excludeDirs) {
        $dirs = $excludeDirs -split '\s+' | ForEach-Object { $_.Trim('"').Trim() }
        foreach ($d in $dirs) {
            if ($d) { $argsList += "/XD `"$d`"" }
        }
    }
    $excludeFiles = $txtExcludeFiles.Text.Trim()
    if ($excludeFiles) {
        $files = $excludeFiles -split '\s+' | ForEach-Object { $_.Trim('"').Trim() }
        foreach ($f in $files) {
            if ($f) { $argsList += "/XF `"$f`"" }
        }
    }

    return "robocopy " + ($argsList -join " ")
}

function Update-PreviewIfReady {
    if ($null -ne $txtKodOnizleme) {
        $cmd = Get-RobocopyArgs
        if ($cmd) {
            $txtKodOnizleme.Text = $cmd
        } else {
            $txtKodOnizleme.Text = "Lütfen kaynak ve hedef klasörleri seçin."
        }
    }
}

# ================== OLAY BAĞLANTILARI ==================
$txtKaynak.Add_TextChanged({ Update-PreviewIfReady })
$txtHedef.Add_TextChanged({ Update-PreviewIfReady })
$txtLogPath.Add_TextChanged({ Update-PreviewIfReady })
$txtExcludeDirs.Add_TextChanged({ Update-PreviewIfReady })
$txtExcludeFiles.Add_TextChanged({ Update-PreviewIfReady })

$radioNone, $radioS, $radioE, $radioMIR | ForEach-Object {
    $_.Add_CheckedChanged({ Update-PreviewIfReady })
}
$chkZ, $chkB, $chkNP, $chkTBD, $chkD, $chkA, $chkT, $chkS, $chkO, $chkU, $chkDCOPYT, $chkMT | ForEach-Object {
    $_.Add_CheckedChanged({ Update-PreviewIfReady })
}
$numR, $numW, $numMT | ForEach-Object {
    $_.Add_ValueChanged({ Update-PreviewIfReady })
}

$form.Add_Shown({
    Update-PreviewIfReady
})

try {
    $form.ShowDialog() | Out-Null
}
catch {
    [System.Windows.Forms.MessageBox]::Show("Script hatası: $($_.Exception.Message)", "Kritik Hata", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}