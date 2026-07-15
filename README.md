# 🛡️ Kolay Ağ Yedekleme Asistanı (Robocopy GUI)

Windows bilgisayarlar, yerel ağ paylaşım klasörleri ve NAS (Network Attached Storage) cihazları için yedekleme süreçlerini otomatikleştiren, PowerShell ve Windows Forms (GUI) tabanlı kullanıcı dostu bir yedekleme asistanıdır. 

Bu araç, Windows'un güçlü ve güvenilir kopyalama motoru **Robocopy**'yi karmaşık komut satırı parametreleriyle uğraşmak zorunda kalmadan görsel bir arayüz üzerinden yönetmenizi sağlar.

---

## ✨ Öne Çıkan Özellikler

*   **Görsel Klasör Seçimi:** Kaynak ve hedef klasörleri Windows gezgini ile kolayca seçin.
*   **Çoklu Kopyalama Modları:** Alt klasörleri dahil etme (/E, /S) veya kaynakla hedefi birebir eşitleyen **Ayna (Mirror - /MIR)** modu seçenekleri.
*   **Dirençli Kopyalama:** Ağ kesintilerinde dosya transferini kaldığı yerden sürdüren **Yeniden Başlatılabilir Mod (/Z)**.
*   **Asenkron Çalışma:** Yedekleme işlemi arka planda yürütülür; kopyalama esnasında arayüz kilitlenmez veya donmaz ("Yanıt Vermiyor" durumuna düşmez).
*   **Zamanlanmış Görev Entegrasyonu:** Tek tıkla o anki yedekleme ayarlarınızı her gün belirlediğiniz saatte otomatik çalışacak şekilde **Windows Görev Zamanlayıcı'ya (Task Scheduler)** ekler.
*   **Gelişmiş Filtreleme:** Yedeklenmesini istemediğiniz klasörleri (/XD) veya uzantıları (/XF) arayüzden tanımlayın.
*   **Çoklu İş Parçacığı (Multi-Threading):** Çok sayıda küçük dosyayı ağ üzerinden kopyalarken hızı katlayan çoklu iş parçacığı (/MT) desteği.
*   **Yönetici Yetki Kontrolü:** Arayüz, gelişmiş Robocopy parametreleri (/B veya ACL kopyalama gibi) için gereken yönetici (Administrator) yetkisini otomatik olarak denetler ve uyarır.
*   **Bilgi Baloncukları (ToolTip):** Arayüzdeki tüm gelişmiş parametrelerin üzerine gelindiğinde ne işe yaradıklarını gösteren detaylı Türkçe açıklamalar.

---

## 📸 Ekran Görüntüsü

*(Buraya projenizin ekran görüntüsünü ekleyebilirsiniz)*
`![Ekran Goruntusu](screenshot.png)`

---

## 🚀 Kurulum ve Çalıştırma

Projenin çalışabilmesi için herhangi bir kuruluma (setup) ihtiyaç yoktur. Taşınabilir (portable) bir PowerShell scriptidir.

1.  Bu depodaki `YedeklemeAraci.ps1` dosyasını bilgisayarınıza indirin.
2.  Dosyanın Türkçe karakterlerinin düzgün görüntülenmesi için **UTF-8 with BOM** kodlamasıyla kaydedildiğinden emin olun.
3.  Script üzerinde sağ tıklayıp **"PowerShell ile Çalıştır"** seçeneğini kullanın.
4.  *Zamanlanmış Görev Oluşturma* ve *Yedekleme Modu (/B)* gibi gelişmiş sistem yeteneklerini kullanabilmek için scripti **Yönetici Olarak** çalıştırmanız önerilir.

---

## 🛠️ Kullanılan Teknolojiler

*   **Scripting Language:** PowerShell
*   **Framework:** .NET Framework (System.Windows.Forms & System.Drawing)
*   **Core Engine:** Windows Robocopy Utility

---

## 📄 Lisans

Bu proje [MIT](LICENSE) lisansı altında sunulmaktadır. Dilediğiniz gibi geliştirebilir, şirket içi altyapılarınızda özgürce kullanabilirsiniz.
