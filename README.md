**Stemming Word dengan menggunakan pascal**

[http://stemming.fastplaz.com/](http://stemming.fastplaz.com/)
***

**Stemming** adalah proses pemetaan dan penguraian bentuk dari suatu kata menjadi bentuk kata dasarnya. Stemming sebagai terapan yang erat dalam [Natural Language Processing](https://medium.com/@luridarmawan/natural-language-processing-nlp-sederhana-dari-carik-bot-78952b618695) sangat berguna bagi Anda yang mendalami tools-tools seperti *Translation*, *Summarization* bahkan juga untuk [ChatBot](http://www.carik.id/) seperti [Carik](http://www.carik.id/).
Penggunaan *stemming* secara luas sudah biasa dilakukan di dalam *Information Retrieval* (pencarian informasi) untuk meningkatkan kualitas informasi yang didapatkan.

*Stemming word* yang digunakan di sini berdasarkan Algoritma Nazief dan Adriani,
dibangun dengan menggunakan bahasa pascal khususnya framework [FastPlaz](http://www.fastplaz.com).

Beberapa variasi kata mungkin tidak terdeteksi dikarenakan banyak hal dan kondisi.
belum termasuk sebagian kata-kata gaul maupun yang tidak gaul.

## How to use it


### Requirements

- [FastPlaz_runtime](http://www.fastplaz.com/)

### Instalasi

**install requirement**

```bash
$ mkdir -p StemmingWord/source/vendors
$ cd StemmingWord/source
$ git clone https://github.com/luridarmawan/StemmingWord.git

# install vendors

$ cd vendors
$ git clone -b development https://github.com/fastplaz/fastplaz.git
```


**Compile dari IDE**

Jika menggunakan Lazarus, buka file "stemming" dan *compile* file tersebut.

Akan terbentuk file binary di 'public_html/stemming/stemming.bin'

**Compile dari Command-Line**

```bash
cd StemmingWord/source/stemming_web/
./clean.sh
./build.sh
.
.
stemming.lpr(13,124)
Assembling (pipe) lib/stemming.s
Compiling resource lib/stemming.or
Linking ../../public_html/stemming/stemming.bin
.
.
source$ _

```

**Custom Build**

untuk konfigurasi custom, misal untuk perubahan path tempat library berada, bisa dilakukan dengan melakukan modifikasi di file **extra.cfg**.


### Demo

Live demo tools ini bisa anda akses dari halamanb [Carik Stemming Tools](https://stemming.carik.id/)
