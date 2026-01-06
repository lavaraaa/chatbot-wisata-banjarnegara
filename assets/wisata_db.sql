-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 02, 2025 at 04:27 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wisata_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `favorit`
--

CREATE TABLE `favorit` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `wisata_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `komentar`
--

CREATE TABLE `komentar` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `wisata_id` int(11) NOT NULL,
  `isi` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `parent_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `laporan_komentar`
--

CREATE TABLE `laporan_komentar` (
  `id` int(11) NOT NULL,
  `komentar_id` int(11) NOT NULL,
  `pelapor_id` int(11) NOT NULL,
  `alasan` text DEFAULT NULL,
  `tanggal_lapor` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

CREATE TABLE `likes` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `wisata_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rating`
--

CREATE TABLE `rating` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `wisata_id` int(11) NOT NULL,
  `rating` tinyint(4) NOT NULL CHECK (`rating` between 1 and 5),
  `review` text DEFAULT NULL,
  `images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`images`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `photoURL` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `created_at`, `photoURL`) VALUES
(22, 'admin', 'admin@wisata.com', '$2b$10$uDjfTmUgm72p.htmhU6FJej2lYURHtgzElwDVbtro2YtBpEpzQxQG', 'admin', '2025-05-07 18:42:17', 'http://localhost:3000/uploads/1754673404414-Wisata Banjarnegara Emblem Design.png'),
(24, 'ell', 'latiffrahman@gmail.com', '$2b$10$o/tONCijejYBxO.GI1Tffu77YMblEs5stpNKKMUeur8clRB4a2LcW', 'user', '2025-05-07 20:29:13', 'http://localhost:3000/uploads/1752895937082-5.png'),
(28, 'galang', 'user123@gmail.com', '$2b$10$G7LwtnOjUFgrNjE5Xbj5l.yOdZ0h7/p8u3BiZDDIqIN4ZKwee93qK', 'user', '2025-05-10 20:34:53', NULL),
(30, 'ucup', 'ucup1234@gmail.com', '$2b$10$JIfycszyATg5.qa09XTycecAzuY9aixWriwKosHJOQun7o.X1khxS', 'user', '2025-06-03 05:05:39', 'http://localhost:3000/uploads/1752724495563-padang savana.jpg'),
(32, 'zaid', 'zaid@gmail.com', '$2b$10$c6OGodU0y6e/2U7HWS43gOvts/1lcAu1Gz0//ku79FXRlavObmPmK', 'user', '2025-07-18 00:32:57', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `wisata`
--

CREATE TABLE `wisata` (
  `id` int(11) NOT NULL,
  `judul` varchar(255) NOT NULL,
  `gambar` varchar(255) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `jam_buka` varchar(10) DEFAULT NULL,
  `jam_tutup` varchar(10) DEFAULT NULL,
  `no_telepon` varchar(20) DEFAULT NULL,
  `harga_tiket` decimal(10,2) DEFAULT NULL,
  `link_gmaps` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `kategori` varchar(255) DEFAULT NULL,
  `fasilitas` text DEFAULT NULL,
  `galeri` text DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `wisata`
--

INSERT INTO `wisata` (`id`, `judul`, `gambar`, `deskripsi`, `jam_buka`, `jam_tutup`, `no_telepon`, `harga_tiket`, `link_gmaps`, `created_at`, `kategori`, `fasilitas`, `galeri`, `alamat`) VALUES
(88, 'Kompleks Candi Dieng Banjarnegara', '1753421234498.png', 'Candi di Kawasan Dieng merupakan kumpulan candi Hindu beraliran Syiwa yang diduga merupakan candi tertua di Jawa. Candi-candi di Kawasan Dieng sendiri terbagi dalam beberapa kelompok dan tersebar lokasinya. Adapun nama masing-masing candi diambil dari nama-nama tokoh pewayangan pada kitab Mahabarata.\r\n\r\n\r\n\r\nKomplek Candi Arjuna terdiri dari 5 buah candi yang tersusun dalam dua deret. Deret timur terdiri dari empat bangunan candi yang semuanya menghadap ke barat yaitu Candi Arjuna, Candi Srikandi, Candi Puntadewa dan Candi Sembadra. Sedang deret barat hanya tinggal satu candi yaitu Candi Semar.\r\n\r\nCandi Gatotkaca terletak di sebelah barat Telaga Balekambang. Perjalanan menuju candi ini cukup singkat karena letaknya yang tak jauh dari Komplek Candi Arjuna. Candi Gatotkaca memiliki kala-makara yang khas. Kala berupa wajah raksasa yang menyeringai tanpa rahang bawah dan makara yang berupa ukiran sulur-sulur.\r\n\r\nCandi Setyaki, Candi Nakula, Candi Sadewa, Candi Petruk, dan Candi Gareng, terletak tidak jauh dari Candi Gatotkaca di dekat Gangsiran Aswatama. Namun saat ini yang masih dapat dilihat hanya Candi Setyaki sementara candi lainnya hanya tersisa reruntuhannya saja.\r\n\r\nKelompok Candi Dwarawati terletak paling utara di antara candi-candi Dieng lainnya. Candi ini berada di kaki Gunung Prau, Dieng. Kunjungan ke candi ini dapat dilakukan dalam perjalanan kembali dari Candi Bima dan Kawah Sikidang. Kelompok Candi Dwarawati terdiri atas 4 candi yaitu Candi Dwarawati, Candi Abiyasa, Candi Pandu, dan Candi Margasari. Akan tetapi saat ini yang berada dalam kondisi relaf utuh hanya nggal Candi Dwarawati. Pada halaman depan candi terdapat susunan batu yang mirip sebuah lingga dan yoni.\r\n\r\nCandi Bima merupakan candi termuda, terbesar dan juga paling tinggi di Kawasan Dataran Tinggi Dieng. Candi ini konon juga dipercaya sebagai candi yang paling wingit atau bertuah. Candi Bima dibangun dengan gaya arsitektur India, tepatnya campuran gaya arsitektur India Utara dan India Selatan.\r\n\r\nBagian atap Candi Bima terdiri dari beberapa angkatan dimana setiap angkatan terdapat hiasan kepala yang disebut â€œArca Kuduâ€. Hal inilah yang membuat Candi Bima unik dan berbeda dengan candi lainnya di Indonesia.', '07:00', '16:00', '085771597440', 15000.00, 'https://maps.app.goo.gl/Sct4ztjyVNto94Ge7', '2025-07-25 05:27:14', '[\"Dieng\"]', '[\"Warung kopi\"]', '[\"1753421234835.webp\",\"1753421234835.jpg\"]', 'Karangsari, Dieng Kulon, Kec. Batur, Kab. Banjarnegara, Jawa Tengah 53456'),
(89, 'Kawah Sikidang Dieng Banjarnegara', '1753421456899.jpg', 'Kawah Sikidang Dieng Banjarnegara merupakan Situs kawah vulkanis yang mengeluarkan gas belerang alami, menawarkan masker, suvenir & rental sepeda motor.', '07:00', '16:00', '081234567890', 15000.00, 'https://maps.app.goo.gl/JajNiSaGsijaLzLz7', '2025-07-25 05:30:56', '[\"Dieng\"]', '[\"Oleh oleh\",\"Jeep\",\"Jasa foto\"]', '[\"1753421456900.jpg\",\"1753421456935.jpg\",\"1753421456938.jpg\"]', 'QWH3+WH8, Bakal Buntu, Dieng Kulon, Kec. Batur, Kab. Banjarnegara, Jawa Tengah 53456'),
(90, 'Padang Savana Dieng Bukit Pangonan Banjarnegara', '1753421686436.jpg', 'Padang Savana', '07:00', '16:00', '081234567890', 15000.00, 'https://maps.app.goo.gl/QcnfnFKLaB11Jx2GA', '2025-07-25 05:34:46', '[\"Dieng\"]', '[\"Warung kopi\",\"akses jalan\"]', '[\"1753421686437.jpeg\",\"1753421686439.jpeg\",\"1753421686443.jpg\"]', 'QWQ5+53F Savana, Karangsari, Dieng, Batur, Banjarnegara, Central Java 53456'),
(91, 'Tugu 0KM Dieng Banjarnegara', '1753421857822.png', 'Tugu 0 Kilometer Dieng merupakan salah satu landmark ikonik yang terletak di kawasan dataran tinggi Dieng, tepatnya di wilayah administratif Kabupaten Banjarnegara, Jawa Tengah. Tugu ini menjadi penanda titik awal perhitungan jarak di kawasan Dieng dan sekaligus simbol awal perjalanan wisata di dataran tinggi yang kaya akan keindahan alam dan warisan budaya tersebut. Lokasinya berada di area strategis yang dikelilingi oleh perbukitan hijau, udara sejuk khas pegunungan, dan suasana yang masih asri, membuatnya menjadi spot favorit untuk berfoto maupun sebagai titik kumpul wisatawan sebelum menjelajahi objek-objek wisata populer lainnya di sekitar Dieng seperti Kawah Sikidang, Telaga Warna, dan Candi Arjuna. Keberadaan tugu ini bukan hanya memiliki fungsi simbolis, tetapi juga menandai titik penting dalam pengembangan pariwisata Banjarnegara yang berbasis potensi lokal dan ekowisata.\r\n\r\nSecara visual, Tugu 0 Km Dieng memiliki desain yang sederhana namun bermakna, sering kali dihiasi dengan ornamen atau motif yang merepresentasikan kearifan lokal serta ciri khas budaya Dieng. Di sekitar tugu biasanya terdapat papan penunjuk atau informasi jarak menuju destinasi-destinasi wisata lain di wilayah Dieng maupun luar kawasan, menjadikannya juga sebagai pusat orientasi geografis. Selain menjadi ikon wilayah, tempat ini juga sering digunakan sebagai lokasi acara pembukaan berbagai kegiatan budaya dan festival, seperti Dieng Culture Festival, yang tiap tahunnya menarik ribuan pengunjung dari berbagai daerah. Dalam konteks pengembangan pariwisata digital dan sistem rekomendasi tempat wisata, Tugu 0 Km Dieng dapat dijadikan salah satu referensi utama sebagai destinasi unggulan yang patut dikunjungi, terutama bagi wisatawan yang ingin merasakan titik awal eksplorasi eksotisnya alam dan budaya Dieng Plateau.', '00:00', '00:00', '081234567890', 15000.00, 'https://maps.app.goo.gl/NDcHaQDH5J1atRuv5', '2025-07-25 05:37:37', '[\"Dieng\"]', '[\"Warkop\",\"Terminal\"]', '[]', 'Jl. Dieng No.13, Pauan, Dieng Kulon, Kec. Batur, Kab. Banjarnegara, Jawa Tengah 53456'),
(92, 'Bukit Scooter Dieng Banjarnegara', '1753422224428.jpg', 'Bukit Scooter Dieng Banjarnegara', '00:00', '00:00', '085702445047', 20000.00, 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d15833.315307775547!2d109.89021463304755!3d-7.203274399999996!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2e700d013a7c0625%3A0x177f4e81819e8dcf!2sBukit%20Skoter!5e0!3m2!1sid!2sid!4v1753422201227!5m2!1sid!2sid', '2025-07-25 05:43:44', '[\"Dieng\"]', '[\"Warung kopi\",\"Camp\"]', '[\"1753422224428.jpg\",\"1753422224781.webp\",\"1753422224782.jpg\"]', 'Jl. Masjid Nurul Huda No.31, Krajan, Dieng Kulon, Kec. Batur, Kab. Banjarnegara, Jawa Tengah 53456'),
(93, 'Telaga Dringo Dieng Banjarnegara', '1753422517192.jpg', 'Telaga Dringo Dieng Banjarnegara', '07:00', '16:00', '-', 25000.00, 'https://maps.app.goo.gl/YLdkT2UoahbezZFv5', '2025-07-25 05:48:37', '[\"Dieng\"]', '[\"Camp\",\"Parkir\",\"Toilet\"]', '[\"1753422517205.webp\",\"1753422517205.webp\",\"1753422517205.webp\",\"1753422517205.jpg\",\"1753422517206.jpg\"]', 'Sidomulyo, Pekasiran, Kec. Batur, Kab. Banjarnegara, Jawa Tengah'),
(94, 'Telaga Merdada Dieng Banjarnegara', '1753422698992.jpg', 'Telaga Merdada Dieng Banjarnegara', '07:00', '16:00', '-', 15000.00, 'https://maps.app.goo.gl/ejsgMEycmjkxa1T28', '2025-07-25 05:51:39', '[\"Dieng\"]', '[\"Camp\",\"Tempat foto\",\"Parkir\",\"Toilet\"]', '[\"1753422698998.webp\",\"1753422698998.webp\"]', 'Pauan, Karangtengah, Kec. Batur, Kab. Banjarnegara, Jawa Tengah'),
(95, 'Museum Kailasa Dieng Banjarnegara', '1753423098400.jfif', 'Nama Kailasa berasal dari nama salah satu gunung tempat tinggal Dewa Syiwa. Nama ini disandangkan pada bangunan museum ini karena kepurbakalaan Dieng sangat identik dengan pemujaan terhadap Dewa Syiwa yang dapat diketahui dari peninggalan percandian maupun prasasti.\r\n\r\nLokasi bangunan museum Kailasa terletak dibawah bukit pangonan yang menurut penuturan warga sering ditemukan berbagai peninggalan sejarah atau tepatnya di seberang Candi Gatutkaca,Â  secara administratif masuk wilayah desa Dieng kulon, Kecamatan Batur Kab. Banjarnegara. Letak persisnya tepat berada di seberang pintu masuk kawasan wisata komplek Candi Arjuna / Candi Gatotkaca yang populer di Dieng.\r\n\r\nBangunan museum kailasa terdiri dari 4 bangunan utama yaitu tempat untuk menyimpan benda-benda cagar budaya, tempat untuk ruang informasi /artefak tentang Dieng dan pemutaran film tentang Dieng, bangunan toilet danÂ  mushola dan bangunan untuk tempat pertunjukan dan pertemuan besar.\r\n\r\nHarga tiket masuk Museum Kailasa di Dieng hanya berkisar Rp5.000 saja untuk per orangnya, adapunÂ  untuk jam operasional wisata Museum Dieng Kailasa yakni terbuka untuk umumÂ  pada setiap harinya. Dan bisa anda kunjungi mulai pukul 04.30 hingga sore hari di jam 16.00 WIB.\r\n\r\nSelain menawarkan keindahan alam dan budaya di Dataran Tinggi Dieng terdapat peninggalan sejarah. Di dieng, para wisatawan dalam menambah pengetahuan tentang benda peninggalan purbakala di Museum Kailasa. Museum kailasa ini didirikan pada tahun 1998 dan Museum Kailasa diresmikan pada tanggal 28 Juli 2008 oleh Menteri Kebudayaan dan Pariwisata Republik Indonesia Ir Jero Wacik.\r\n\r\nDi siniÂ  para wisatawan dapat memperoleh informasi tentang terbentuknya Dataran Tinggi Dieng. selain itu para wisatawan dapat meliahat secara langsung benda peninggalan purbakala dan ragam kearifan lokal masyarakat Dieng. Tidak hanya itu, di museum kailasa para wisatawan dapat melihat film tentang jejak peradaban Dieng.\r\n\r\nBagi yang memiliki waktu cukup dapat bersantai di gazebo paling atas dengan menaiki tangga yang diberi ornamen batu alam tampak menyatu dengan bangunan museum dan di tempat paling tinggi inilah kita dapat melihat terangkatnya kabut yang menyelimuti candi pada pagi hari sebelum silver sunrise muncul menerangi dataran tinggi Dieng, Pemandangan ini sangat sulit dapat dinikmati dari tempat lain, akan tetapi memang informasi ini belum tersebar dengan baik sehingga jarang yang menjadikan tempat ini sebagai Favorit place untuk menikmati pemandangan langka, terlebih lagi pada saat embun upas datang dan menyelimuti rerumputan dan semua tetumbuhan yang ada di dataran tinggi Dieng, tiada duanya pemandangan seperti ini semua tampak putih dan kalau pas matahari muncul akan terlihat pantulan cahaya kemilau dari dataran yang semula dipenuhi rerumputan ini.\r\n\r\nBangunan museum yang dilengkapi dengan berbagai fasilitas seperti toilet, mushola, cafÃ©, dan tempat parkir, sedangkan bangunan lain berupa gazebo â€“ gazebo kecil di bagian atas yang dapat digunakan sebagai tempat istirahat dan menyaksikan pemandangan desa Dieng dan komplek candi arjuna.\r\n\r\nBagi anda yang akan ke Kawah Sikidang pun pasti akan melewati museum ini yang posisinya persis berada di tepi jalan. Sehingga Lokasinya pun terbilang cukup strategis sehingga mudah dijangkau dari berbagai arah kedatangan anda.', '07:00', '16:00', '-', 15000.00, 'https://maps.app.goo.gl/mXr1nEkhvh7SVSs36', '2025-07-25 05:58:18', '[\"Dieng\"]', '[\"Toilet\",\"Toilet khusus pengguna kursi roda\",\"Parkir\"]', '[\"1753423098403.jpg\",\"1753423098757.jpg\",\"1753423098763.jfif\"]', 'QWR4+J4H, Karangsari, Dieng Kulon, Kec. Batur, Kab. Banjarnegara, Jawa Tengah 53456'),
(98, 'Kawah Candradimuka Dieng Banjarnegara', '1753424071113.jpeg', 'Kawah Candradimuka Dieng Banjarnegara', '07:00', '16:00', '-', 15006.00, 'https://maps.app.goo.gl/o2Pa3CvwGPv7xPkP7', '2025-07-25 06:14:31', '[\"Dieng\"]', '[\"Parkir\",\"Toilet\"]', '[\"1753424071123.JPG\"]', 'Sidomulyo, Pekasiran, Kec. Batur, Kab. Banjarnegara, Jawa Tengah'),
(99, 'Kawah Sileri Dieng Banjarnegara', '1753536606655.jpg', 'Kawah Sileri adalah kawah vulkanik aktif yang terletak di lereng barat kluster Gunung Pagerkandang-Sipandu di Dataran Tinggi Dieng. Kawah ini merupakan kawah yang paling aktif di Dataran Tinggi Dieng dan pernah meletus beberapa kali. Kawah ini terluas di Dieng dan dinamakan Kawah Sileri karena air kawah yang gemulak dan mendidih persis seperti bekas cucian beras atau leri. Meskipun berpotensi bahaya, Kawah Sileri telah menjadi objek wisata alam di DT Dieng yang menawarkan pemandangan yang indah', '07:00', '16:00', '08223456788', 15000.00, 'https://maps.app.goo.gl/88NPLA8jHtXiQ5Mq6', '2025-07-26 13:30:06', '[\"Dieng\"]', '[\"Parkir\",\"Toilet\"]', '[]', 'RV4M+QGC, Krajan, Kepakisan, Kec. Batur, Kab. Banjarnegara, Jawa Tengah 53456'),
(100, 'Telaga Balekambang Dieng Banjarnegara', '1753537022495.jpg', 'Telaga ini terletak di sebelah selatan Kompleks Candi Arjuna, berjarak sekitar 200 meter melalui jalan setapak, terdapat sebuah telaga yang dianggap suci oleh masyarakat Dataran Tinggi Dieng. Inilah Telaga Balaikambang.\r\n\r\nPemberian nama â€œbalaikambangâ€ pada telaga ini berdasarkan fenomena yang terjadi di sini. â€œBalaikambangâ€ berasal dari â€œbal kumambangâ€ yang dapat diartikan sebagai tanah yang mengambang\r\n\r\nDi telaga seluas hampir 3 hektare ini, tanah yang dilemparkan ke bagian tengah telaga akan mengapung. Selain itu, saat berjalan di sisi telaga, dapat dirasakan tanah yang ada di sini bergoyang-goyang. Tanah tersebut seperti mengambang di atas air.\r\n\r\nTelaga ini merupakan tempat pelaksanaan dua upacara penting. Yang pertama, upacara pelarungan rambut gembel anak bajang yang sudah dipotong melalui prosesi panjang sebelumnya, yang kedua adalah upacara Syiwalatri â€“ hari penebusan dosa. Umat akan datang ke telaga dan mandi di sini untuk membersihkan diri dari segala dosa dan kesalahan. Selain itu, telaga ini pun kadang dijadikan sebagai tempat pelarungan rambut gimbal yang telah dipotong setelah upacara ruwatan anak berambut gimbal.\r\n\r\nPada hari-hari biasa, ketika tidak diadakan upacara sakral, telaga yang berada di ketinggian sekitar 2.100 meter di atas permukaan laut ini dijadikan sebagai tempat pemancingan oleh warga sekitar. Air telaga pun dimanfaatkan untuk keperluan pertanian.\r\n\r\nUntuk dapat berkunjung ke Telaga Balaikambang, pengunjung dapat membeli tiket masuk ke Kompleks Candi Arjuna seharga Rp20.000. Tips jika Anda berkunjung ke telaga ini, berhati-hatilah ketika berjalan di sekitar telaga. Tanah yang bergoyang-goyang akan membuat langkah gontai dan tidak jarang tanah yang dipijak akan tenggelam ke dalam air yang ada di bawahnya.', '07:00', '16:00', '08223456788', 15000.00, 'https://maps.app.goo.gl/699gHwNYMbf5hXK69', '2025-07-26 13:37:02', '[\"Dieng\"]', '[\"Kuliner\",\"Parkir\",\"Toilet\"]', '[]', 'QWR5+R97, Karangsari, Dieng Kulon, Kec. Batur, Kab. Banjarnegara, Jawa Tengah 53456'),
(101, 'Telaga Sewiwi Dieng Banjarnegara', '1753537276906.jpg', 'Telaga Sewiwi merupakan obyek wisata danau yang telah lama ada di Dataran Tinggi Dieng tepatnya terletak di wilayah Desa Wisata Kepakisan. Berjarak hanya 2 km dari Komplek Candi Arjuna Dataran Tinggi Dieng. Obyek Wisata ini beberapa tahun terakhir oleh masyarakat setempat difungsikan sebagai arena pemancingan yang terkadang banyak juga para penghobi mancing dari daerah lain datang ke telaga sewiwi untuk menyalurkan hobinya.\r\n\r\nNamun itu cerita lama, Obyek Wisata Telaga Sewiwi kondisi sekarang jauh lebih cantik dan indah dan berfungsi sebagai Rest Area, yang di lengkapi dengan fasilitas rumah makan, toilet, mushola, kios cinderamata dan beberapa gazebo unik untuk bersantai dan beristirahat sambil menikmati indahnya alam yang menakjubkan, juga pintu gerbang yang membentang menyerupai sewiwi/sayap yang gagah dan membuat seolah wisatawan mengharuskan untuk mendokumentasikan kunjungannya dan sebagai bahan cerita dengan saudara maupun teman agar merasa tidak ketinggalan sebagai generasi millenial, maka sangatlah layak obyek wisata ini sangat cocok untuk wisata keluarga.\r\n\r\nDari beberapa telaga yang ada di Dataran Tinggi Dieng,Â Telaga Sewiwi merupakan telaga yang paling mudah dijangkau oleh wisatawan. Letak telaga ini sangat strategis, karena berada di pinggir jalan raya jadi wisatawan langsung sampai dilokasi.\r\n\r\nAksesbilitas / kondisi jalan yang lumayan bagus, baik ditempuh dari arah Karangobar – Wanayasa maupun dari arah Kabupaten Batang, wisatawan dapat menjangkau tempat wisata ini dengan menggunakan kendaraan bermotor maupun menggunakan mobil. Obyek wisata danau ini juga berdekatan dengan objek wisata lain seperti Sumur Jalatunda, Curug Sirawe, Kawah Sileri, Telaga Merdada dan D’Qiano Hot Spring.\r\n\r\nTelaga Sewiwi salah satu telaga yang sudah diberdayakan oleh Dinas Pariwisata dan Kebudayaan Kabupaten Banjarnegara dari segi amenitas sudah lebih reprentatif dengan fasilitas yang ada dan lebih menarik,\r\nmaka semua wisatwan yang berkunjung ke Rest Area Telaga Sewiwi untuk membuang sampah pada tempat yang sudah disediakan, tidak membuang sampah sembarangan dengan memperhatikan dan menerapkan budaya SAPTA PESONA antara lain: BERSIH – INDAH – TERTIB – SEJUK – AMAN – RAMAH TAMAH – KENANGAN', '07:00', '16:00', '08223456788', 15000.00, 'https://maps.app.goo.gl/U1pRBMmgbAx2y4oi9', '2025-07-26 13:41:16', '[\"Dieng\"]', '[\"Parkir\",\"Toilet\",\"Gazebo\"]', '[]', 'QVXJ+PJF, Sirangan, Kepakisan, Kec. Batur, Kab. Banjarnegara, Jawa Tengah 53456'),
(102, 'Air Terjun Curug Pletuk Pagedongan', '1753550722561.jpg', 'Pesona Air Terjun di Tengah Hutan\r\n\r\nCurug Pletuk memiliki ketinggian lebih dari 150 meter, dengan empat tingkatan yang dikelilingi pepohonan rimbun. Suara gemuruh air terjun yang jatuh menciptakan suasana yang menyegarkan dan menenangkan bagi setiap pengunjung yang datang. Lokasinya yang berada di kaki Gunung Slamet membuat perjalanan menuju Curug Pletuk sangat memanjakan mata, karena wisatawan akan disuguhi pemandangan alam yang memukau sepanjang perjalanan.\r\n\r\nUntuk menambah kenyamanan pengunjung, disediakan tangga estetik yang memungkinkan wisatawan mendaki hingga mencapai puncak air terjun. Tangga ini dirancang khusus dengan gaya yang menyatu dengan alam, memberikan pengalaman unik sekaligus menjadi spot foto favorit yang instagrammable. Pengunjung cukup membayar Rp15.000,- untuk masuk ke curug, gratis 1 botol Teh Botol Sosro dan akses ke kolam renang. \r\n\r\n \r\n\r\nJam Operasional\r\n\r\nCurug Pletuk buka setiap hari Senin hingga Jumat mulai pukul 08.00 WIB hingga pukul 16.00 WIB. Sedangkan pada akhir pekan atau hari libur nasional, wisata ini buka mulai pukul 08.00 WIB hingga pukul 17.00 WIB.\r\n\r\n \r\n\r\nDesa Wisata Pesangkalan dan Pengelolaannya\r\n\r\nMelalui program Desa Wisata, Desa Pesangkalan mengambil langkah besar dalam pengelolaan Curug Pletuk untuk memaksimalkan potensi wisata alam. Tidak hanya fokus pada peningkatan jumlah kunjungan wisata, pengelolaan ini juga bertujuan untuk menjaga kelestarian lingkungan di sekitarnya. Berbagai program konservasi diterapkan untuk memastikan bahwa keindahan Curug Pletuk tetap terjaga bagi generasi mendatang.\r\n\r\nPartisipasi masyarakat dalam pengelolaan destinasi wisata ini juga membuka peluang ekonomi bagi warga desa. Mereka dapat berperan dalam berbagai layanan, mulai dari pengelolaan loket tiket hingga penyewaan peralatan. “Kami berupaya mengembangkan pariwisata ini dengan tetap menjaga keseimbangan ekosistem yang ada, agar keberlanjutannya dapat dinikmati dalam jangka panjang,” ujar Kepala Desa Pesangkalan, Bapak Rahman Widodo.\r\n\r\n \r\n\r\nFasilitas Pendukung: Gazebo, Camping Ground, Coffee Shop, Toko Oleh-oleh, dan Kolam Renang.\r\n\r\n\r\n\r\nDi sekitar Curug Pletuk, telah disediakan area istirahat yang nyaman bagi pengunjung untuk bersantai setelah menikmati keindahan air terjun. Area ini dilengkapi dengan gazebo dan tempat duduk yang terbuat dari bahan alami, menciptakan suasana yang tetap menyatu dengan alam. Gazebo ini sering menjadi lokasi pelaksanaan gathering atau rapat berbagai komunitas dan instansi. \r\n\r\nDi bawah curug, terdapat camping ground dimana wisatawanbisa menginap dan menghabiskan malam di area Curug Pletuk sambil menikmati gemricik air. Wisatawan juga semakin dimanjakan dengan Paket BBQ yang disediakan oleh pengelola, serta area karaoke dan akustik. Pengunjung juga bisa memesan minuman dan snack di coffee shop. \r\n\r\nSelain itu, terdapat juga toko oleh-oleh kecil yang dikelola oleh warga setempat, yang menjual berbagai produk lokal seperti makanan ringan, souvenir, dan kerajinan tangan. Hal ini tidak hanya memudahkan wisatawan untuk membawa pulang kenang-kenangan, tetapi juga memberikan kontribusi terhadap perekonomian masyarakat sekitar.\r\n\r\nDi area pintu masuk, terdapat kolam renang yang secara gratis pengunjung ke curug bisa mengakses (include tiket masuk). Hal ini menjadi daya tarik sendiri bagi wisatawan. \r\n\r\n \r\n\r\nSpot Fotografi yang Menakjubkan\r\n\r\nKeindahan Curug Pletuk menjadikannya lokasi favorit bagi para pecinta fotografi. Air terjun yang menjulang dengan latar belakang hutan hijau menciptakan suasana yang sempurna untuk berbagai jenis pengambilan gambar. Tangga estetik yang mengarah ke puncak air terjun menjadi salah satu spot foto paling diminati karena desainnya yang unik dan menyatu dengan alam.\r\n\r\nDengan berbagai keunggulan dan fasilitas pendukung yang ditawarkan, Curug Pletuk siap menjadi destinasi wisata favorit baru di Jawa Tengah, menghadirkan pengalaman wisata alam yang memikat dan fasilitas yang nyaman bagi para pengunjung.', '07:30', '17:00', '08223987675', 15000.00, 'https://maps.app.goo.gl/r84weCt3szMHkwS27', '2025-07-26 17:25:22', '[\"Curug/Air Terjun\"]', '[\"Camp\",\"Parkir\",\"Toilet\",\"Caffe Shop\",\"Kolam Renang\",\"Pusat Oleh-Oleh\"]', '[\"1753550722900.jpeg\",\"1753550722945.jpg\"]', 'Dukuh Pletuk, Pesangkalan, Kec. Pagedongan, Kab. Banjarnegara, Jawa Tengah 53418'),
(103, 'Sumur Jalatunda Dieng Banjarnegara', '1753550949453.jpg', 'Di Desa Pekasiran, Kecamatan Batur, Kabupaten Banjarnegara, terdapat sebuah sumur berukuran raksasa. Sumur ini bernama Sumur Jalatunda. Disebut raksasa karena sumur ini memiliki diameter sepanjang 90 meter. Sementara, kedalaman sumur diperkirakan lebih dari 100 meter. Sumur Jalatunda yang berada di kawasan Dataran Tinggi Dieng Kabupaten Banjarnegara merupakan kepundan Gunung Prahu Tua yang meletus bersamaan dengan terbentuknya Dataran Tinggi Dieng.\r\n\r\nAda sebuah mitos yang dipercaya masyarakat sekitar mengenai sumur ini. Konon Sumur Jalatunda merupakan salah satu pintu ghaib menuju penguasa laut selatan. Jika ada yang mampu melempar batu hingga ke sisi di seberang, melintasi permukaan sumur, dipercaya permintaan orang tersebut akan terkabul. Mitos tersebut pula yang menjadi dasar pemberian nama pada sumur ini. â€œJalaâ€ berarti jaring, sementara â€œtundaâ€ berarti yang belum terlaksana. Jika diartikan, Sumur Jalatunda berarti sumur yang dapat menampung semua permintaan yang selama ini tertunda.\r\n\r\nSelain itu, ada beberapa cerita mengenai sumur ini. Menurut kepercayaan masyarakat setempat, sumur ini merupakan pintu menuju Sapta Pratala (bumi lapis ketujuh). Sementara, terkait dengan Epos Mahabarata, sumur ini merupakan tapak tumit Bima ketika bertarung melawan naga raksasa.\r\n\r\nSumur Jalatunda dibuka untuk umum setiap hari dari jam 07.00 WIB sampai jam 16.00 WIB. Tiket masuk ke tempat wisata ini Rp5.000 per orang. Sebagai catatan, jalan menuju tempat wisata ini kurang bagus. Sebaiknya tidak menggunakan kendaraan jenis sedan jika ingin berkunjung ke tempat ini.', '07:00', '17:00', '08223987675', 15000.00, 'https://maps.app.goo.gl/2jNvVGL36X1uViCG9', '2025-07-26 17:29:09', '[\"Dieng\"]', '[\"Parkir\",\"Toilet\"]', '[]', 'Sidomulyo, Pekasiran, Kec. Batur, Kab. Banjarnegara, Jawa Tengah'),
(104, 'Bukit Sipandu Dieng Banjarnegara', '1753551162349.jpg', 'Bukit Sipandu adalah salah satu puncak di Dataran Tinggi Dieng. Berada pada Ketinggian 2.241 mdpl, wisata alam ini terletak di perbatasan Kabupaten Batang dan Banjarnegara. Salah satu rute umum ke puncak Sipandu adalah melewati Jalur Pawuhan yang terletak di Desa Karangtengah, Kecamatan Batur, Banjarnegara.', '00:00', '00:00', '08223987675', 15000.00, 'https://maps.app.goo.gl/aMoaNMz75n3bxFxs6', '2025-07-26 17:32:42', '[\"Dieng\"]', '[\"Camp\"]', '[]', 'Bitingan, Kepakisan, Kec. Batur, Kab. Banjarnegara, Jawa Tengah'),
(105, 'Air Terjun Curug Pitu', '1753551751133.webp', 'Air Terjun Curug Pitu terletak di Kemiri, Sigaluh, Kemiri, Banjaranegara, Kab. Banjarnegara, Jawa Tengah 53481', '08:00', '16:00', '08563188406', 15000.00, 'https://maps.app.goo.gl/UWvrMiJYuMKGrnNVA', '2025-07-26 17:42:31', '[\"Curug/Air Terjun\"]', '[\"Gazebo\",\"Toilet\",\"Musholla\",\"Tempat Makan\",\"Akses mobil mudah\"]', '[]', 'HQP5+424, Kemiri, Sigaluh, Kemiri, Banjaranegara, Kab. Banjarnegara, Jawa Tengah 53481'),
(106, 'Air Terjun Curug Sikopel', '1753552338529.jpg', 'Air Terjun Curug Sikopel', '07:00', '15:30', '08563188406', 15000.00, 'https://maps.app.goo.gl/JRed8qABEGFVxmYz7', '2025-07-26 17:52:18', '[\"Curug/Air Terjun\"]', '[\"Caffe Shop\"]', '[]', 'Sinoman, Babadan, Kec. Pagentan, Kab. Banjarnegara, Jawa Tengah 53455'),
(107, 'Air Terjun Genting', '1753552842053.jpg', 'Air Terjun Genting', '08:00', '17:00', '0286592793', 15000.00, 'https://maps.app.goo.gl/gxrbg48hreZdve1v6', '2025-07-26 18:00:42', '[\"Curug/Air Terjun\"]', '[\"Camp\",\"Parkir\",\"Toilet\",\"Caffe Shop\"]', '[]', 'QQCR+XVH, Dusun Grogol, Grogol, Kec. Pejawaran, Kab. Banjarnegara, Jawa Tengah 53454'),
(108, 'Air Terjun Curug Merawu', '1753553150654.jpg', 'Air Terjun Curug Merawu', '08:00', '17:00', '081234567890', 15000.00, 'https://maps.app.goo.gl/1qsgZBLGdTFDuwds7', '2025-07-26 18:05:50', '[\"Curug/Air Terjun\"]', '[]', '[]', 'QQFW+RGM, Jl. Tieng, Dusun Grogol, Tieng, Kec. Batur, Kab. Banjarnegara, Jawa Tengah 53456'),
(109, 'Air Terjun Semangkung Pejawaran', '1753553366709.jpg', 'Air Terjun Semangkung Pejawaran', '08:00', '17:00', '081234567890', 15000.00, 'https://maps.app.goo.gl/T6hW5tbzh9bxRdDs5', '2025-07-26 18:09:26', '[\"Curug/Air Terjun\"]', '[]', '[]', 'QV33+CCP, Dusun Semangkung, Semangkung, Kec. Pejawaran, Kab. Banjarnegara, Jawa Tengah 53454'),
(110, 'Air Terjun Sigenjreng Pejawaran', '1753553492469.jpg', 'Air Terjun Sigenjreng Pejawaran', '08:00', '17:00', '081234567890', 15000.00, 'https://maps.app.goo.gl/xztYxbYJ5czKBCxU9', '2025-07-26 18:11:32', '[\"Curug/Air Terjun\"]', '[]', '[]', 'QV23+Q46, Dusun Semangkung, Semangkung, Kec. Pejawaran, Kab. Banjarnegara, Jawa Tengah 53454'),
(111, 'Air Terjun Curug Sinom Indah Kalibening', '1753553597846.jpg', 'Air Terjun Curug Sinom Indah Kalibening', '08:00', '17:00', '081234567890', 15000.00, 'https://maps.app.goo.gl/LocdFNckwTfS3Fbs6', '2025-07-26 18:13:17', '[\"Curug/Air Terjun\"]', '[]', '[]', 'QMMR+497, Area Hutan/Perkebunan, Kasinoman, Kec. Kalibening, Kab. Banjarnegara, Jawa Tengah 53458'),
(112, 'Air Terjun Curug Sipawon Wanayasa', '1753553943238.webp', 'QQC9+M7F, Sawah, Wanaraja, Kec. Wanayasa, Kab. Banjarnegara, Jawa Tengah 53457', '08:00', '17:00', '081234567890', 15000.00, 'https://maps.app.goo.gl/KQRFAxWvYEgwq7wR6', '2025-07-26 18:19:03', '[\"Curug/Air Terjun\"]', '[]', '[]', 'QQC9+M7F, Sawah, Wanaraja, Kec. Wanayasa, Kab. Banjarnegara, Jawa Tengah 53457'),
(113, 'Air Terjun Curug Panaraban Wanayasa', '1753554065147.jpg', 'Air Terjun Curug Panaraban Wanayasa', '08:00', '17:00', '081234567890', 15000.00, 'https://maps.app.goo.gl/2NTxkhaNLFVi65hM9', '2025-07-26 18:21:05', '[\"Curug/Air Terjun\"]', '[]', '[]', 'QQ9C+X9C, Legoksayem, Kec. Wanayasa, Kab. Banjarnegara, Jawa Tengah 53457'),
(114, 'Surya Yudha Park Banjarnegara', '1753554938189.jpg', 'Surya Yudha Park Banjarnegara', '08:00', '17:00', '082115888001', 25000.00, 'https://maps.app.goo.gl/ovR8fNbjosm2NGkY7', '2025-07-26 18:35:38', '[\"Wisata Rekreasi\"]', '[\"Wifi\",\"Restaurant\",\"Parkir Gratis\",\"Jemputan Bandara\",\"Bioskop\",\"Hotel\"]', '[]', 'Jl. Raya Rejasa No.KM. 1, Rejasa, Kec. Madukara, Kab. Banjarnegara, Jawa Tengah 53482'),
(115, 'Surya Yudha Park 2 Banjarnegara', '1753555073976.jpg', 'Surya Yudha Park 2 Banjarnegara', '08:00', '20:00', '081234567890', 15000.00, 'https://maps.app.goo.gl/4HAtivus6GjCz36E9', '2025-07-26 18:37:53', '[\"Wisata Rekreasi\"]', '[\"Toilet Umum\",\"Taman Bermain\"]', '[]', 'Jl. Raya Rejasa, Kutabanjarnegara, Kec. Banjarnegara, Kab. Banjarnegara, Jawa Tengah 53418'),
(116, 'TRMS Serulingmas Banjarnegara', '1753555240505.jpg', 'TRMS Serulingmas Banjarnegara', '07:00', '16:00', '0286591933', 20000.00, 'https://maps.app.goo.gl/GbTaV4RZQEhHkoY77', '2025-07-26 18:40:40', '[\"Wisata Rekreasi\",\"Wisata Edukasi\"]', '[]', '[]', 'Kutabanjarnegara, Kec. Banjarnegara, Kab. Banjarnegara, Jawa Tengah 53418'),
(117, 'Kolam Renang Serulingmas', '1753555330958.jpg', 'Kolam Renang Serulingmas Banjarnegara', '07:00', '16:00', '081234567890', 15000.00, 'https://maps.app.goo.gl/kSz4PcxYuLemywi28', '2025-07-26 18:42:10', '[\"Wisata Rekreasi\"]', '[]', '[]', 'JM5P+Q7G, Jl. Selamanik, Kutabanjarnegara, Kec. Banjarnegara, Kab. Banjarnegara, Jawa Tengah 53418'),
(118, 'The Pikas Artventure Resort (Wisata Arung Jeram Sungai Serayu)', '1753555673375.jpg', 'The Pikas Artventure Resort (Wisata Arung Jeram Sungai Serayu)', '08:00', '16:00', '0286593000', 25000.00, 'https://maps.app.goo.gl/jBmHcunDEwtuaGDM8', '2025-07-26 18:47:53', '[\"Wisata Rekreasi\"]', '[]', '[]', 'Jl. Raya Madukara, Kutayasa, Kec. Madukara, Kab. Banjarnegara, Jawa Tengah 53482'),
(119, 'Dermaga Bendungan Panglima Besar Jenderal Sudirman', '1753556101427.jpeg', 'Bendungan Panglima Besar Jenderal Sudirman', '08:00', '17:00', '081234567890', 50000.00, 'https://maps.app.goo.gl/V5iQwMcJSxvSqfgEA', '2025-07-26 18:55:01', '[\"Waduk\"]', '[]', '[]', 'JJ54+3FR, Tapen Krajan, Karangjambe, Kec. Wanadadi, Kab. Banjarnegara, Jawa Tengah 53461'),
(120, 'Monumen Pembangunan Waduk Mrica', '1753556272256.jpg', 'Monumen Pembangunan Waduk Mrica', '08:00', '17:00', '081234567890', 15000.00, 'https://maps.app.goo.gl/MY9j9xAHwYKGgVq79', '2025-07-26 18:57:52', '[\"Waduk\"]', '[\"Restaurant\",\"Toilet\",\"Parkir\"]', '[]', 'JH5X+437, Tapen Jurang, Tapen, Kec. Wanadadi, Kab. Banjarnegara, Jawa Tengah 53461'),
(121, 'Padang Golf Waduk Mrica', '1753556400837.jpg', 'Padang Golf Waduk Mrica', '07:00', '16:00', '081234567890', 15000.00, 'https://maps.app.goo.gl/smeoQeLiU61oVep56', '2025-07-26 19:00:00', '[\"Waduk\"]', '[]', '[]', 'JH6X+22Q, Tapen Jurang, Tapen, Kec. Wanadadi, Kab. Banjarnegara, Jawa Tengah 53461'),
(122, 'Wisata Seakong Waduk Mrica Wanadadi', '1753556574736.jpg', 'Wisata Seakong Waduk Mrica Wanadadi', '08:00', '20:00', '-', 3000.00, 'https://maps.app.goo.gl/RMqsEnXyvVdeZJz97', '2025-07-26 19:02:55', '[\"Wisata Kuliner\",\"Wisata Rekreasi\"]', '[]', '[]', 'Dusun Dua, Wanadadi, Kec. Wanadadi, Kab. Banjarnegara, Jawa Tengah'),
(123, 'Kuliner Alun - Alun Banjarnegara', '1753611812214.jpg', 'Kuliner Alun - Alun Banjarnegara', '00:00', '23:59', '081234567890', 0.00, 'https://maps.app.goo.gl/WCApD7JBDtMYSeo99', '2025-07-27 10:23:32', '[\"Wisata Kuliner\"]', '[\"Karaoke\",\"Musholla\",\"Parkir\",\"Live Musik\",\"Panggung Hiburan\",\"Toilet\"]', '[]', 'Jl. Raya Brengkok, Kutabanjarnegara, Kec. Banjarnegara, Kab. Banjarnegara, Jawa Tengah 53415'),
(124, 'Taman Kardjono Pucang Banjarnegara', '1753612434680.jpg', 'Taman pejuan Letnan Kardjono terletak kurang lebih empat kilometer arah barat dari kota Banjarnegara, tepatnya di desa Semampir. Taman pejuang Letnan Kardjono ini dibangun untuk menghormati perjuangan Letnan Kardjono yang gugur dimedan perang. Dalam taman pejuang ini, terdapat banyak relief yang menggambarkan keadaan semasa perjuangan melawan penjajah, kekejaman tentara Belanda, serta ada pula relief penghadangan konvoi Belanda yang dilakukan oleh pejuang RI di Banjarnegara. Dalam taman pejuang ini juga terdapat replika pesawat tempur yang dahulu digunakan untuk melawan Belanda', '00:00', '23:59', '0', 0.00, 'https://maps.app.goo.gl/8Cg4GR8cGrktb4DC8', '2025-07-27 10:33:54', '[\"Wisata Rekreasi\"]', '[\"Kuliner\",\"Parkir\"]', '[]', 'JM28+HFC, Sidakarsa, Pucang, Kec. Bawang, Kab. Banjarnegara, Jawa Tengah 53471'),
(125, 'Alun -Alun Banjarnegara', '1753612619686.webp', 'Alun -Alun Banjarnegara', '00:00', '23:59', '0', 0.00, 'https://maps.app.goo.gl/vpStiFFtbqHntT8w7', '2025-07-27 10:36:59', '[\"Wisata Rekreasi\"]', '[\"Anjing boleh masuk\",\"Parkir\",\"Masjid\"]', '[]', 'Jl. Pemuda, Kutabanjarnegara, Kec. Banjarnegara, Kab. Banjarnegara, Jawa Tengah 53415'),
(126, 'Taman Balai Budaya Banjarnegara', '1753612892674.jpg', 'Balai Budaya Banjarnegara', '08:00', '21:00', '0', 0.00, 'https://maps.app.goo.gl/eZgkVRuEZcxAtHpf8', '2025-07-27 10:41:33', '[\"Wisata Budaya\"]', '[\"Parkir\",\"Toilet\"]', '[]', 'JM4M+XPF, Kutabanjarnegara, Kec. Banjarnegara, Kab. Banjarnegara, Jawa Tengah 53418'),
(127, 'Desa Wisata Dawuhan Wanayasa', '1753621135674.jpg', 'Banjarnegara memiliki sederet pesona wisata dengan keindahan alamnya yang unik dan eksotis. Hampir sebagian besar wilayah Banjarnegara ini didominasi zona perbukitan dan pegunungan tua. Pesona keindahannya pun mensaratkan adanya kerentanan yang mendorong warga masyarakatnya hidup berdampingan dan harmonis dengan kondisi yang ada. Upaya ketangguhan dan kreatifitas cara pandang ini dapat kita jumpai di Desa Wisata Dawuhan, yang letaknya tidak begitu jauh dari Wisata Dieng.Â \r\n\r\nDesa Wisata Dawuhan ini berada di Kecamatan Wanayasa Kabupaten Banjarnegara Provinsi Jawa Tengah Indonesia. Desa yang berada di ketinggian 800-1000 meter di atas permukaan laut ini, dibatasi dengan Kali Penaraban dan terletak di bawah lereng 3 gunung, Gunung Gajah, Gunung Wangi, dan Gunung Kendil. Luas wilayah desa ini sebesar 192,063 hektar dengan jumlah populasi penduduk 2.156 jiwa. Lahan garapan desa ini cukup subur. Sumber daya air cukup melimpah di desa ini.\r\n\r\nBermula dari kajian risiko partisipatif, para pemuda desa ini menemukan bahwasanya eksotisme pemandangan Kali Penaraban bisa dijadikan potensi ekonomi. Sehingga wahana yang pertama kali lahir adalah Wahana Arung Jeram Tubing Sungai Penaraban. Seiring berjalannya waktu, area ini juga berubah menjadi rest area, dimana rest area ini sesungguhnya juga merupakan lokasi teraman dari kerentanan yang berasal dari Gunung Wangi.\r\n\r\nSelain itu, sejak tahun 2014 lereng gunung wangi tersebut banyak ditanami Pohon Kopi Arabika yang menjadi salah satu produk unggulan desa Dawuhan dan uniknya 10 % hasil panen kopi ini juga telah diamanahkan menjadi kas kebencanaan desa. Hal tersebut terbukti efektif berhasil mencegah terjadinya tanah longsor dan membuat perekonomian warga menjadi meningkat.\r\n\r\n\r\n\r\nPada pengembangannya, di lokasi rest area ini kemudian diselenggarakan daya tarik wisata pendukung secara swadaya, mulai dari kolam terapi ikan, camping ground, arena outbond sampai pelayanan Homestay yang mengandalkan rumah-rumah warga. Dan sebagai siasat bertahan dari dampak pandemi, lahirlah daya tarik wisata baru yaitu Pasar Rengrang.\r\n\r\nPasar Rengrang adalah pasar unik yang menyajikan makanan khas jawa dengan konsep Jadul (zaman dulu) dan para pegunjung jika akan membeli jajanan di sini harus memakai uang koin yang terbuat dari kayu senilai Rp. 2000 dan bisa menukarkannya diloket yang sudah disediakan\r\n\r\nMakanan yang disajikan di Pasar Rengrang ini adalah aneka macam jajanan tempo dulu yang sudah tidak keluar dan sangat langka di masa kini, dan karena memang konsepnya dari alam kembali ke alam maka semua makanan yang ada disini adalah berbasis tradisional alamiah. Mulai dari sego jagung, leye, gudeg, pecel, getuk, bubur srintil, Klepon dan banyak lagi lainnya. Tidak hanya, di Pasar Rengrang ini disediakan juga aneka Kopi giling asli dari petani Dawuhan dengan harga yang terjangkau.\r\n\r\nDi sisi lain, adanya rest area dan pasar rengrang kemudian juga membidani lahirnya Komunitas Pelestari Sungai Penaraban, yang berupaya menjadi kelest\r\n\r\n\r\n\r\narian sungai penaraban ini dengan kegiatan bersih-bersih sungai, arung jeram tubing, outbond dan penyelenggaraan sanggar resiliensi. Sebuah sanggar yang menyajikan paket-paket edukasi ketangguhan, ekonomi kreatif warga dan kelestarian lingkungan.\r\n\r\nSebagai informasi, pada tanggal 14 November 2022 yang lalu, Desa Wisata Dawuhan menjadi perwakilan Kabupaten Banjarnegara masuk dalam 10 besar Gelar Desa Wisata Jawa Tengah 2022.', '09:00', '17:00', '081210224432', 20000.00, 'https://maps.app.goo.gl/P27mpuzKPZEk6Gxs6', '2025-07-27 12:58:55', '[\"Desa Wisata\"]', '[\"Camping Ground\",\"Terapi Ikan\",\"Parkir\",\"Toilet\",\"Homestay\"]', '[]', 'Dawuhan, Kec. Wanayasa, Kab. Banjarnegara, Jawa Tengah 53457'),
(128, 'Kampung Gagot Kutawuluh', '1753621447354.jpg', 'Kabupaten Banjarnegara mempunyai destinasi wisata yang menarik untuk liburan akhir pekan bersama keluarga. Inilah Kampung Gagot, wisata edukasi pertanian hingga peternakan. Kampung Gagot yang berlokasi di Desa Kutawuluh Kecamatan Purwanegara, Banjarnegara menyuguhkan destinasi wisata yang berbeda. Di sana, wisatawan benar-benar bisaÂ  menyatu dengan alam. Bahkan, mereka bisa belajar langsung seputar dunia pertanian, peternakan hingga perikanan. Paket Edukasi Pertanian, Pembuatan Pupuk Organik dan peternakan merupakan paket wisata utama di Kampung Gagot.\r\n\r\nDi setiap rumah atau pekarangan, wisatawan berhenti untuk mendapat penjelasan terkait pertanian maupun peternakan. wisatawan diberi informasi bagaimana cara menanam tanaman seperti terong, melon dan tanaman holtikultura lainnya.Â  Selain itu, wisatawan juga diberitahu bagaimana membuat pupuk, baik pupuk kandang maupun pupuk kompos. Wisatawan juga diperbolehkan untuk praktik langsung terkait kegiatan pertanian dan peternakan tersebut. Kemudian di sektorÂ perikanan, wisatawan tidak hanya diajarkan seputar merawat ikan, namun juga hal-hal lain. Misalnya, bagi wisatawan anak-anak diberi tempat untuk menangkap ikan kecil dan wisatawan dewasa disediakan tempat pemancingan.\r\n\r\nÂ  Â Â  Â Â  \r\n\r\nUniknya di Kampung Gagot ini, semua hewan ternak dan tanaman dikelola oleh pemiliknya masing-masing. Jadi, pemilik hewan berkewajiban membersihkan kandang serta menjelaskan kepada wisatawan. Jadi wisata edukasi ini melibatkan semua warga. Termasuk toilet, warga harus membersihkan toilet di rumah masing agar layak digunakan wisatawan.\r\n\r\nUntuk mengikuti wisata edukasi ini, wisatawan cukup membayar Rp 25.000,-Â  untuk semua edukasi pertanian, perikanan dan peternakan. Namun, jika sekalian dengan menikmati olahannya, Rp 45.000,- per orang.\r\n\r\nWisata Edukasi di Kampung Gagot ini banyak dikunjungi siswa sekolah dari berbagai daerah di Indonesia. Sehingga, rumah warga juga dimanfaatkan untuk penginapan para wisatawan. Tarif untuk menginap Rp 150.000,-Â  sudah termasuk satu kali makan.Â ', '07:00', '21:00', '081384658934', 25000.00, 'https://maps.app.goo.gl/yK6WDLBeAu4RUEGC7', '2025-07-27 13:04:07', '[\"Desa Wisata\",\"Wisata Edukasi\"]', '[]', '[]', 'Dusun Gagot, RT.01/RW.05, Tinembang, Kutawuluh, Kab. Banjarnegara, Jawa Tengah 53472'),
(129, 'Desa WIsata Depok Kecamatan Bawang', '1753621621832.jpg', 'Desa Wisata Depok adalah Desa Wisata yang berada di Kecamatan Bawang dan berpotensi besar terhadap kemajuan wisata di Banjarnegara, didukung dengan sumber daya manusia dan sumber daya alam yang memadai. Desa wisata ini secara geografis sangat strategis karena berdekatan dengan Bandar udara Jenderal Besar Soedirman di Kabupaten Purbalingga. Dioperasikannya Bandar udara ini tentu saja berpotensi terhadap kunjungan wisata di Desa Wisata Depok.\r\n\r\nDaya tarik wisata di Desa Wisata Depok yang bisa dinikmati oleh para wisatawan ketika berkunjung kesana antara lain tubing, outbond, wahana permainan air, dan panjat tebing. Desa Wisata Depok cocok untuk pilihan wisata di akhir pekan dan hari libur bersama keluarga dan teman-teman.', '07:00', '22:00', '-', 15000.00, 'https://maps.app.goo.gl/YZJAiEaCY6jLMeUe9', '2025-07-27 13:07:01', '[\"Desa Wisata\"]', '[]', '[]', 'Kuncen, Depok, Kec. Bawang, Kab. Banjarnegara, Jawa Tengah 53471'),
(130, 'Desa Wisata D\'Kuwondogiri Blambangan', '1753622242188.jpg', 'Desa Wisata Blambangan adalah desa wisata berbasis agro yang masuk wilayah Kecamatan Bawang. Berjarak 6 km ke arah barat (arah Purwokerto) dari alun alun Banjarnegara, di sini wisatawan dapat melihat kegiatan pertanian dan peternakan dari warga lokal, serta diberikan kesempatan untuk ikut terlibat dan belajar secara langsung.\r\n\r\nBanyak potensi yang dikembangkan di Desa Wisata Blambangan ini, selain terdapat agrowisata terdapat juga beberapa atraksi wisata lain yang bisa dinikmati oleh wisatawan, mulai dari wisata sejarah Makam Raden Tumenggung Joyonegoro I dan Makam Raden Tumenggung Joyonegoro II , wisata alam Tubing Kali Belimbing, wisata kuliner dan lokasi out bound di rest area sepeda d’Kuwondogiri, resto tengah hutan Wanagro Wanatulale, serta yang paling baru adalah broadwalk atau jembatan kayu sepanjang 500 meter di tengah area persawahan yang diberi nama â€œBroadwalk Baruklintingâ€.\r\n\r\nSemua potensi wisata di Desa Blambangan dikelola oleh Pokdarwis (kelompok Sadar Wisata) Minakjingga yang terbentuk sebagai kesadaran seluruh elemen masyarakat desa pada potensi yang ada di wilayahnya. Selain itu juga terdapat kelompok pemuda dusun kuwondogiri yang aktif mengolah dan mengelola dusun mereka dan menamakan diri sebagai D’kuwondogiri.Â  Â  Â Â \r\n\r\nDâ€™Kuwondogiri sendiri adalah sebuah kelompok masyarakat yang terbentuk dari sebuah gagasan bersama para pemuda dusun Kuwondogiri Desa Blambangan Kecamatan Bawang yang merasa sangat prihatin dengan perkembangan generasi remaja di era milenial ini dalam menyikapi kemajuan teknologi, terutama penggunaan telepon genggam. Karena seperti kita semua tahu, bahwa dengan semakin majunya teknologi ini maka semakin berubah pula (secara drastis) gaya hidup remaja menjadi gaya hidup yang cenderung pasif dan kurang peka terhadap lingkungannya.\r\n\r\nDengan harapan bisa menghasilkan produk produk kreatif yang berguna bagi masyarakat, kelompok yang sudah dilegalkan dengan Surat Keputusan Kepala Desa Tentang Pembentukan kelompok masyarakat nomor 01/A.1/Dâ€™K/Kwd/XII/2019 tanggal 2 Desember 2019 ini kemudian bergerak di bidang keagamaan, sosial, pariwisata, lingkungan dan keamanan dan bahkan pendidikan. Mereka kemudian menggerakkan masyarakat untuk ikut bekerja sama dalam menyelenggarakan beberapa kegiatan rutin yang melibatkan semua pihak.\r\n\r\nSalah satu kegiatan rutin di bidang olah raga yaitu Gowes tengah sawah yang memanfaatkan jalan desa Bandingan â€“ Blambangan sepanjang kurang lebih 1,5 km dan berada tepat di tengah persawahan warga dengan pemandangan yang luar biasa. Juga kegiatan setiap hari Sabtu Sore dan Minggu Pagi yaitu Senam tengah sawah yang juga menjadi ajang berolah raga dan silaturohmi untuk warga sekitar.\r\n\r\nDi bidang sosial, kelompok masyarakat Dâ€™Kuwondogiri melakukan berbagai kegiatan seperti melakukan Sosialisasi Pandemi Covid-19 terhadap masyarakat di desa Blambangan pada umumnya dan masyarakat dusun Kuwondogiri pada khususnya. Donasi covid-19 juga dilakukan sehingga berhasil mencukupi kebutuhan pokok beberapa warga yang terdampak secara ekonomi dari wabah Covid-19.Â Ada juga kegiatan Donor darah yang rutin dilakukan dalam kurun waktu tiga bulan dengan menggandeng PMI Kabupaten Banjarnegara sebagai partner.\r\n\r\nDi bidang pelestarian lingkungan, Dâ€™Kuwondogiri melakukan kegiatan pemasangan himbauan-himbauan bagi masyarakat untuk menjaga kelestarian alam dengan tujuan untuk menjaga ekosistem di sekitar kita agar tetap lestari.\r\n\r\nDi bidang pertanian kegiatan yang dilakukan antara lain adalah mengelola lahan persawahan dengan di tanami hasil bumi berupa sayur dan juga tanaman pokok lainya. Sekedar informasi, seluruh permodalan berasal dari usaha para pemuda dusun Kuwondogiri sendiri alias mandiri, dengan produk unggulannya adalah sayur kangkung â€œEndolita D,Kuwondogiriâ€ . Sayur ini ternyata digemari oleh masyarakat sekitar karena merupakan salah satu alternative sayur yang murah menjadi berkelas dan bergizi.\r\n\r\nKemudian, aspek yang digarap dengan serius oleh masyarakat terutama pemuda dusun ini adalah di bidang Pariwisata. Kegiatan dengan memanfaatkan sebagian lahan persawahan untuk rest area sepeda, dan kemudian dipadukan dengan hasil kreatifitas sehingga tercipta â€œRest Area Gili Loriâ€, yaitu sebuah tempat yang memanfaatkan area kosong dimana pengunjung (terutama pesepeda) bisa istirahat di tempat khusus yang nyaman dan menyajikan makanan makanan tradisional. Lokasi ini dikelola dengan apik oleh kelompok ibu-ibu di dusun kuwondogiri yang tergabung dalam â€œSrikandi Kuwondogiri ', '08:00', '17:00', '0', 0.00, 'https://maps.app.goo.gl/3Thynee1a2urgHB46', '2025-07-27 13:17:22', '[\"Desa Wisata\"]', '[]', '[]', 'JJ5P+J77, Dusun Kuwondogiri, Blambangan, Kec. Bawang, Kab. Banjarnegara, Jawa Tengah'),
(131, 'Desa Wisata Giritirta Pejawaran', '1753622471432.jpg', 'Desa Giritirta Kecamatan Pejawaran merupakan desa yang terletak di sebelah utara Kabupaten Banjarnegara (33 km dri kota kabupaten) dengan kondisi lokasi yang berbukit. Memiliki Sumber mata air yang melimpah meskipun belum bias dinikmati oleh sluruh warga karena terbatasnya sumber dana yang ada di masyarakat.\r\n\r\nNama desa ini berasal dari kata GIRITIRTA (Giri = Gunung, Tirta = Air) memiliki berbagai sumber daya alam antara lain Batu Lempeng, Batu Andersit, Tras (pasir local), dan juga memiliki Obyek Wisata Alam Eksotis yakni Curug Merawu, Curug Genting, dan dua sumber air panas debit tinggi dalam satu kawasan wisata.\r\n\r\nDesa Giritirta terdiri dari 5 dusun (Beran, Melikan, Sendangarum, Giritirta, dan pandanarum dengan Jumlah penduduk sebanyak 2,805 jiwa yang terdiri dari 736 Kepala Keluarga dengan luas wilayah 282 Ha. Sebagian besar mata pencaharian penduduk Desa Giritirta adalah petani sayur-mayur sepertiÂ  kentang, kobis, tomat, cabe, wortel, waluh jipang, muncang, bayam, ranti, dan juga palawija (jagung). Sedangkan sebagian yang lain ada yg mata pencahariannya sebagai buruh tani dan pemecah batu seplit serta sebagi peternak baik kambing, domba maupun sapi.\r\n\r\nDalam upaya peningkatan kesejahteraan masyarakat petni, Desa Giritirta memiliki Irigasi Sikalong sepanjang 3,5 km dan berpusat di bawah curug merawu. Setiap 3 bulan, masyarkat bergotong-royong memperbaiki saluran irigasi yang memang belum pemanen. Hali ini dilakukan agar pada musim kemarau panjang, petani tetap bisa bercocok tanam.\r\n\r\nSelain Irigasi, Giritirta memiliki jalan desa sepanjang 8 km dengan rincianÂ  jalan aspal 3,5 km, jalan makadam, 0,5 km, dan jalan tanah sepanjang 3,5 km.\r\nDisisi lain, sebagian wilayah Desa Giritirta adalah tanah labil yg mudah bergerak dan rawan longsor, sehingga ada 3 Dusun yang sebagian wilayahnya tidaj nyaman untuk pemukiam penduduk seperti Dusun Beran, Dusun Sendangarum, dan Dusun Giritirta.\r\n\r\nDibidang pendidikan Desa Giritirta memiliki 1 buah Paud, 3 TK, 2 M.I, dan 1 SD yaitu SD Negeri Giritirta SD Rintisan MBS yang patut dibanggakan karena sering dikunjungi untuk studi banding dari berbagai daerah termasuk dari Papua.\r\n\r\nDibidang agama, desa Giritirta memiliki 5 Masjid, 6 Musholla, 10 TPQ, dan 1 pondok pesantren.', '00:00', '23:59', '0', 0.00, 'https://maps.app.goo.gl/4FvMdNxeZ7eYLz2e8', '2025-07-27 13:21:11', '[\"Desa Wisata\"]', '[]', '[]', 'QQ9R+G3, Area Sawah/ Kebun, Giritirta, Kec. Pejawaran, Kab. Banjarnegara, Jawa Tengah 53454'),
(132, 'Desa Wisata Gumelem Wetan', '1753622932581.jpg', 'Merupakan desa wisata rintisan, Desa Wisata Gumelem Wetan memiliki banyak potensi, terutama wisata budaya. Daya tarik wisata yang ada di Desa Wisata Gumelem Wetan antara lain Masjid Kuno Jami At-Taqwa, Makam Ki Ageng Giring, Pemandian Banyu Anget Pingit, Batik Tulis Gumelem,\r\n\r\n\r\n\r\nLokasinya yang berbatasan dengan Desa Gumelem Kulon dan merupakan bekas peninggalan Kademangan Gumelem, mengakibatkan peninggalan kebudayaan yang ada di sini masih berkaitan dengan yang ada di Desa Gumelem Kulon. Di antaranya adalah Masjid Kuno Jami At-Taqwa yang terletak di dua desa, yakni Desa Gumelem Kulon dan Gumelem Wetan dengan para pengelola masjidnya yang berasal dari dua desa pula. Selain itu, Pemandian Banyu Anget Pingit yang dipercaya berkhasiat menyembuhkan berbagai penyakit memiliki letak pancuran air hangat yang berada di Desa Gumelem Kulon, padahal air yang memancar berada di Desa Gumelem Wetan.\r\n\r\nPesona lain dari Desa Wisata Gumelem Wetan adalah ekonomi kreatif pande besi. Masyarakat setempat, sedikit banyak masih melestarikan cara pembuatan alat-alat pertanian dan senjata tajam dari besi seperti pisau, sabit/celurit, bendho, cangkul, kapak, dll. Wisatawan dapat melihat dan belajar secara langsung cara pembuatan alat-alat pertanian tersebut. Dari beberapa tempat pembuatan batik tulis dan cap khas Gumelem yang saat ini masih aktif dan eksis diantaranya Batik Giri Alam dan Batik Bu Giat. Di sini wisatawan juga diberi kesempatan untuk melihat proses pembuatan batik tulis dan cap khas Gumelem serta bisa belajar membatik.', '09:00', '21:00', '087831255404', 0.00, 'https://maps.app.goo.gl/9k77CeJy3jz8bz319', '2025-07-27 13:28:52', '[\"Desa Wisata\"]', '[\"Parkir\",\"Toilet\"]', '[]', 'RT.03/RW.03, Sayangan, Gumelem Wetan, Kec. Susukan, Kab. Banjarnegara, Jawa Tengah 53475');
INSERT INTO `wisata` (`id`, `judul`, `gambar`, `deskripsi`, `jam_buka`, `jam_tutup`, `no_telepon`, `harga_tiket`, `link_gmaps`, `created_at`, `kategori`, `fasilitas`, `galeri`, `alamat`) VALUES
(133, 'Desa Wisata Karangtengah Kecamatan Batur', '1753623233483.jpg', 'Desa Wisata Karangtengah berlokasi di Dataran Tinggi Dieng, Kecamatan Batur. Desa ini berada di lereng Gunung Sipandu bagian selatan. Desa tersebut berada pada sekitar 500 meter dari objek wisata Dieng (Desa Dieng Wetan dan Kulon) ke arah Banjarnegara.\r\n\r\nDi desa ini terdapat dukuh tujuan wisata yang bernama Dukuh Pawuhan, dukuh ini memang memiliki nama unik. Pawuhan diartikan sebagai â€œtempat sampahâ€. Nama ini tentu tidak muncul begitu saja. Para penghuninya percaya bahwa nama itu telah ada pada zaman Kerajaan Kalingga yang memang berpusat di kawasan tersebut. Konon, Kalingga memiliki peternakan gajah yang merupakan binatang kesayangan putri raja. Pawuhan merupakan tempat pembuangan kotoran gajah tersebut. Makanya, tanah di dukuh itu terkenal subur karena humus dari kotoran gajah tersebut.\r\n\r\nSebagian besar mata pencaharian warga desa ini betumpu pada sektor pertanian terutama budidaya sayur sehingga pertanian menjadi daya tarik bagi wisatawan. Bukit Sipandu juga menjadi daya tarik wisata alam yang menawarkan panorama yang cantik dan menawan.\r\n\r\n\r\n\r\nDi desa ini pula terdapat pengolahan panas bumi (Geothermal) yang dikelola PT. Geo Dipa Energy dan direncanakan akan menajdi salah satu lokasi untuk wisata edukasi panas bumi. Di desa ini juga terdapat terdapat Pos Pengamatan Gunung Api Dieng untuk memantau gas beracun CO2 dari Kawah Timbang, Gunung Dieng.\r\n\r\nDi Desa Karang Tengah, terdapat atraksi wisata alam berupa Telaga Merdada dan budidaya kentang. Di telaga Merdada, wisatawan dapat menikmati paronama alam, berkemah, bermain kano, dan sekedar berfoto ria di gazebo.', '00:00', '23:59', '087831255404', 0.00, 'https://maps.app.goo.gl/mQNNjnR5mkXwYTPn9', '2025-07-27 13:33:53', '[\"Desa Wisata\"]', '[\"Gazebo\",\"Parkir\",\"Toilet\"]', '[]', 'QVQQ+MP, Pauan, Karangtengah, Kec. Batur, Kab. Banjarnegara, Jawa Tengah'),
(134, 'Tikako Caffe & Java Culinary', '1753623471980.jpg', 'Desa Wisata Kalilunjar adalah desa wisata yang terletak di Kecamatan Banjarmangu. Desa ini berbasis wisata alam dan buatan. Wisatawan dapat menikmati hamparan pemandangan dan rumah pohon di Bukit Asmara Situk (BAS). Di samping itu, BAS juga bisa dinikmati keindahannya di malam hari, karena tersedia fasilitas kamar penginapan.\r\n\r\nUntuk urusan kuliner, di Desa Wisata Kalilunjar terdapat Tikako Cafe & Java Culinary. Selain menyajikan makanan untuk wisatawan, Tikako juga merupakan tempat yang asik untuk ber-selfie terutama pada malam hari. Di sian hari, wisatawan dapat menikmati kuliner sambil menikmati suasana segar dari gemercik Sungai Komprat. Arsitektur bangunan Tikako merupakan replikasi bentuk kapal yang unik, dipercantik dengan gemerlap lampu yang menambah suasana romantis di malam hari.', '08:00', '20:00', '081229707222', 25000.00, 'https://maps.app.goo.gl/zvnw5ArxpS9iPnKw8', '2025-07-27 13:37:52', '[\"Wisata Kuliner\"]', '[]', '[]', 'Dusun I, Kalilunjar, Kec. Banjarmangu, Kab. Banjarnegara, Jawa Tengah 53452'),
(135, 'Desa Wisata Pagak', '1753623746425.jpeg', 'BANJARNEGARA Pariwisata: Era Pandemi Covid -19 menjadi tantangan baru di sektor pariwisata karena sangat berdampak pada semua pengelola Desa Wisata maupun para pelaku usaha pariwisata, fenomena ini menjadi tantangan dan kesempatan para pengelola Desa Wisata untuk bersaing dalam mengikuti seleksi ajang BCA Desa Wisata Award 2021, salah satunya Desa Wisata Pagak Kecamatan Purwareja Klampok telah bersaing ketat diantara 460 Desa Wisata se Indonesia yang masuk seleksi dalam 4 kategori Desa Wisata berbasis Alam, Budaya, Kreatif dan Digital.\r\n\r\nKepala Desa Pagak Sudarwo saat di konfirmasi 8/6/21 menjelaskan “Selama pandemi C-19, Desa Wisata Pagak sangat terdampak, seolah denyut pariwisata berhenti, namun kami harus bangkit dan tetap optimis, maka kami dan pengelola Desa Wisata mengikuti ajang BCA Desa Wisata Award 2021dan masuk 20 besar pada kategori Desa Wisata berbasis kreatif”. katanya.\r\n\r\nDalam hal ini kami dan segenap pengelola Desa Wisata Pagak mohon dukungan dan doa restu kepada Pemerintah Daerah Banjarnegara dan seluruh masyarakat semoga Desa Wisata pagak menjadi juara 1, seperti Dawet Ayu yang telah menorehkan citra harum untuk Banjarnegara. imbuhnya.\r\n\r\nHal tersebut diamini oleh Pengelola Desa Wisata Pagak, Pradikta Dimas “Alhamdulillah Desa Wisata Pagak masuk 20 Besar Nominasi BCA Desa Wisata Award 2021, dalam kategori Desa Wisata Berbasis Kreatif. Rasa syukur yang mendalam dan tantangan baru bagi kami untuk terus berproses, kami mohon doa serta dukungannya agar bisa melalui proses selanjutnya, dengan harapan bisa menjadi juara dan mengharumkan Banjarnegara khususnya dalam sektor pariwisata” harap Dimas\r\n\r\nDalam rangkaian jadwal yang telah tersusun kami akan melalui tahap pembinaan selama 2 hari, kemudian dilakukan visiting dan penilian langsung di lokasi dan proses akhir untuk penentuan juara adalah presentasi Profile Desa Wisata Pagak dengan segala potensinya, sedangkan kejuaraan masing – masing nominasi diumumkan 9 Juli 2021.” imbuhnya\r\n\r\nDalam melewati seleksi ajang BCA Desa Wisata Award 2021, pengelola Desa Wisata Pagak dengan dukungan dan doa dari semua pihak sangat optimis dan semangat untuk meraih juara 1, sedangakan reward yang di siapkan dari panitia penyelenggara total hadiah senilai 600 juta untuk semua kategori. ', '07:00', '17:00', '085643691336', 20000.00, 'https://maps.app.goo.gl/KTB7964mPRLi8YNb7', '2025-07-27 13:42:26', '[\"Desa Wisata\"]', '[]', '[]', 'GFF7+88, Jl. Banjar Dawa, Dusun Banjar Anyar, Pagak, Kec. Purwareja Klampok, Kab. Banjarnegara, Jawa Tengah 53474'),
(136, 'Watu Desel Pesangkalan', '1753623927842.jpg', 'Watu Desel Pesangkalan', '08:00', '18:00', '0', 15000.00, 'https://maps.app.goo.gl/cFnAdexM94KZ3KvRA', '2025-07-27 13:45:27', '[\"Wisata Alam\"]', '[]', '[]', 'HP29+5H4, Semagung, Pesangkalan, Kec. Pagedongan, Kab. Banjarnegara, Jawa Tengah 53418'),
(137, 'Wisata Tampomas', '1753624318369.jpg', 'Wisata Tampomas Banjarnegara menampilkan danau luas yang dikelilingi oleh tebing batu andesit yang memukau. Air danau ini berasal dari mata air alami Gunung Tampomas sendiri, menjadikannya tempat yang menenangkan dan indah untuk dinikmati. Bukti peledakan Gunung Tampomas terlihat dari garis-garis tegak lurus di tebing batu, bekas bor untuk menghancurkan gunung.\r\n\r\n\r\n\r\n\r\nLokasi Tampomas Banjarnegara\r\n\r\n\r\nLokasi Tampomas Banjarnegara terletak di Desa Gentansari, Kecamatan Pagedongan, Kabupaten Banjarnegara, Jawa Tengah.\r\n\r\nAkses Menuju Tampomas Banjarnegara\r\n\r\nRute menuju Tampomas Banjarnegara dari pusat kota dapat dilakukan dengan mengarah ke Jalan KH Dahlan, kemudian belok kanan ke Jalan Campur Salam. Jaraknya cukup dekat dengan Alun-Alun Banjarnegara, sekitar 9 km dengan estimasi waktu kurang dari 20 menit.\r\n\r\n\r\n\r\nAkses jalan menuju Tampomas Banjarnegara bisa dilalui dengan berbagai jenis kendaraan, meskipun beberapa titik jalurnya mungkin kurang baik. Bagi penggemar gowes, objek wisata Tampomas ini bisa menjadi tujuan yang menarik.', '06:00', '17:00', '0', 10000.00, 'https://maps.app.goo.gl/z1KETtjzat8crPHj8', '2025-07-27 13:51:58', '[\"Wisata Alam\",\"Wisata Rekreasi\"]', '[]', '[]', 'HJ9W+6JP, Jaten, Gentansari, Kec. Pagedongan, Kab. Banjarnegara, Jawa Tengah 53471'),
(138, 'Gunung Lawe Banjarmangu', '1753624551520.jpg', 'Gunung Lawe Banjarmangu', '00:00', '23:59', '082220618150', 15000.00, 'https://maps.app.goo.gl/nhUQhFT8CMntSXMJA', '2025-07-27 13:55:08', '[\"Wisata Alam\"]', '[\"Camp\"]', '[]', 'MP94+57C, Melikan, Kendaga, Kec. Banjarmangu, Kab. Banjarnegara, Jawa Tengah 53452'),
(139, 'Gunung Lanang Bawang Banjarnegara', '1753624842838.jpg', 'Gunung Lanang Bawang Banjarnegara', '00:00', '23:59', '081807999993', -10.00, 'https://maps.app.goo.gl/dZUg69fkTChAyMEH7', '2025-07-27 13:59:11', '[\"Wisata Alam\"]', '[]', '[]', 'HJ6V+58W, Jl. Wiradrana, Wiradrana, Majalengka, Kec. Bawang, Kab. Banjarnegara, Jawa Tengah 53471'),
(140, 'Wisata Alam Bukit Sikunang, Petuguran, Punggelan, Banjarnegara', '1753625161246.jpg', 'Wisata Alam Bukit Sikunang, Petuguran, Punggelan, Banjarnegara', '09:00', '05:00', '085227731441', 0.00, 'https://maps.app.goo.gl/J3BhwSrVJNa2pgGHA', '2025-07-27 14:06:01', '[\"Wisata Alam\"]', '[]', '[]', 'MJQ7+XF6, GARUNG, RT.04/RW.05, Petuguran, Kec. Punggelan, Kab. Banjarnegara, Jawa Tengah 53462'),
(141, 'Kawasan Wisata Desa & Budaya Paweden', '1753625393624.jpg', 'Paweden, Kawasan Wisata Desa & Budaya', '08:00', '04:30', '082297669816', -20.00, 'https://maps.app.goo.gl/kBh7eetvLL5nNWTn9', '2025-07-27 14:09:53', '[\"Desa Wisata\",\"Wisata Budaya\"]', '[]', '[]', 'Jl. Raya Karangkobar No.KM 17, Kasimpar, Paweden, Kec.Karangkobar, Banjarnegara, Central Java 53453'),
(142, 'Air Terjun Pertinggi', '1753625571402.jpg', 'Air terjun Pertinggi ini oleh penduduk setempat juga dinamakan Curug Pete. Dikala musim hujan, Curug ini akan menampilkan keindahannya, tetapi berbahaya untuk mandi2 karena ada relung tepat ditempat jatuhnya air.\r\nTerletak lebih kurang 200 meter dari jalan provinsi Klampok Gombong', '08:00', '17:00', 'o', 0.00, 'https://maps.app.goo.gl/JxFtC6XMAZjvG9Jg7', '2025-07-27 14:12:51', '[\"Curug/Air Terjun\"]', '[]', '[]', 'FFVJ+J3M, Gandul, Glempang, Kec. Mandiraja, Kab. Banjarnegara, Jawa Tengah 53473'),
(143, 'Arung Jeram Serayu', '1753625849160.jpg', 'Arung Jeram Serayu', '08:00', '16:00', '085247097777', 305000.00, 'https://maps.app.goo.gl/ba6WEXy8jr3qArZ26', '2025-07-27 14:17:29', '[\"Wisata Rekreasi\"]', '[]', '[]', 'Jl. Raya Banjarnegara - Wonosobo No.Km.15, Randegan, Kec. Sigaluh, Kab. Banjarnegara, Jawa Tengah 53481'),
(144, 'Pemandian Air Panas Pingit Gumelem', '1753626008052.jpg', 'Pemandian Air Panas Pingit Gumelem', '00:00', '23:59', '0', 15000.00, 'https://maps.app.goo.gl/E9tdj3befxAmfzCL6', '2025-07-27 14:20:08', '[\"Wisata Alam\",\"Wisata Rekreasi\"]', '[]', '[]', 'Pingit, Gumelem Wetan, Kec. Susukan, Kab. Banjarnegara, Jawa Tengah 53475'),
(145, 'Curug Pundung Sewu Petir Siranti', '1753626116938.jpg', 'Curug Pundung Sewu Petir Siranti', '07:00', '17:00', '0', 0.00, 'https://maps.app.goo.gl/aua8buaziq1EQ7dp6', '2025-07-27 14:21:56', '[\"Curug/Air Terjun\"]', '[]', '[]', 'GH5X+93C, Jl. Raya Kayubima, Kayubima, Petir, Kec. Purwanegara, Kab. Banjarnegara, Jawa Tengah 53472'),
(146, 'Bukit Angkruk Ranis', '1753626611826.jpg', 'Angkruk Ranis', '00:00', '23:59', '0', 0.00, 'https://maps.app.goo.gl/8PyjZ4kSKu8hqgN59', '2025-07-27 14:30:11', '[\"Wisata Alam\"]', '[\"Camp\",\"Warung\"]', '[]', 'PJ28+CWX, Jl. Raya Pandanarum, Area Hutan/Perkebunan, Tlaga, Kec. Pandanarum, Kab. Banjarnegara, Jawa Tengah 53458'),
(147, 'Kalianget Mangunan', '1753626740611.jpg', 'Kalianget Mangunan', '08:00', '18:00', '085328704040', 0.00, 'https://maps.app.goo.gl/DveVcKsKLseX3RdN7', '2025-07-27 14:32:20', '[\"Wisata Alam\"]', '[]', '[]', 'QJ8Q+FX7, Jl. Kalibening - Gripit, Jogjogan, Kalibening, Kec. Kalibening, Kab. Banjarnegara, Jawa Tengah 53458'),
(148, 'Wisata Goa Alam Watu Payung', '1753626831134.jpg', 'Wisata Goa Alam Watu Payung', '00:00', '00:00', '0', 0.00, 'https://maps.app.goo.gl/z1fWewpTnnkoHofJ7', '2025-07-27 14:33:51', '[\"Wisata Alam\"]', '[]', '[]', 'JPW3+5WF, Jl. Bogohan, Bogoan, Rakitan, Kec. Madukara, Kab. Banjarnegara, Jawa Tengah 53482'),
(149, 'Taman Wisata Pulas Garden Sipedang', '1753626940479.jpg', 'Taman Wisata Pulas Garden Sipedang', '07:30', '17:00', '085290180413', 0.00, 'https://maps.app.goo.gl/ykyB5y8stLyVQT3Y6', '2025-07-27 14:35:40', '[\"Wisata Alam\"]', '[]', '[]', 'Sipodang, Sipedang, Kec. Banjarmangu, Kab. Banjarnegara, Jawa Tengah 53452'),
(150, 'Kolam Renang Kopi Kubangan', '1753627058448.jpg', 'Kolam Renang Kopi Kubangan', '07:00', '17:00', '0', 0.00, 'https://maps.app.goo.gl/kLj3H78YiTaM6q9C8', '2025-07-27 14:37:38', '[\"Wisata Rekreasi\"]', '[]', '[]', 'HJ4R+MX4, Jl. Wiradrana, Wiradrana, Majalengka, Kec. Bawang, Kab. Banjarnegara, Jawa Tengah 53471'),
(151, 'Basecamp Rumpit Bike Park', '1753627222113.jpg', 'Basecamp Rumpit Bike Park', '00:00', '23:59', '085290675637', 0.00, 'https://maps.app.goo.gl/vq9HFQHwdbAFMHkA7', '2025-07-27 14:40:22', '[\"Wisata Rekreasi\",\"Wisata Alam\"]', '[]', '[]', 'GF3F+845, Krajan, Salamerta, Kec. Mandiraja, Kab. Banjarnegara, Jawa Tengah 53473'),
(152, 'Kolam Renang Kalionggok', '1753712705913.jpg', 'Kolam Renang Kali Onggok adalah destinasi wisata yang menawarkan suasana khas pedesaan yang asri, sejuk, dan nyaman. Tempat ini cocok untuk menghabiskan waktu bersama keluarga atau teman, jauh dari hiruk-pikuk perkotaan.\r\n\r\nDengan harga tiket masuk yang sangat terjangkau, hanya sekitar Rp10.000 per orang, Anda bisa menikmati berbagai fasilitas yang memadai. Kolam ini memiliki kolam renang untuk dewasa dan anak-anak, sehingga cocok untuk segala usia. Selain itu, tersedia fasilitas seperti mushola yang bersih, toilet yang cukup banyak, serta tempat ganti baju yang nyaman.\r\n\r\nBagi Anda yang ingin bersantai, ada warung yang menyediakan makanan dan minuman, serta live musik yang menambah suasana ceria. Untuk pengalaman yang lebih seru, pengunjung juga bisa mencoba perahu bebek di area kolam. Tidak hanya itu, tersedia pula aula atau tempat rapat yang dapat digunakan untuk acara keluarga atau pertemuan.\r\n\r\nSecara keseluruhan, Kolam Renang Kali Onggok adalah pilihan wisata yang ramah kantong dengan fasilitas lengkap dan suasana yang memanjakan. Sangat direkomendasikan untuk Anda yang ingin menikmati liburan singkat dengan nuansa alam pedesaan.', '07:00', '17:00', '0', 10002.00, '<iframe src=\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3956.3791420318585!2d109.53989137529082!3d-7.4232255925873!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2e6555002218a4df%3A0x35294b7e05b0dad5!2sWisata%20Kalionggok!5e0!3m2!1sid!2sid!4v1753982615378!5m2!1sid!2sid\" width=\"600\" height=\"450\" style=\"border:0;\" allowfullscreen=\"\" loading=\"lazy\" referrerpolicy=\"no-referrer-when-downgrade\"></iframe>', '2025-07-28 14:25:05', '[\"Wisata Rekreasi\"]', '[\"Toilet\",\"Parkir\",\"Warung\"]', '[]', 'HGGV+X9F, Blabar Lor, Adipasir, Kec. Rakit, Kab. Banjarnegara, Jawa Tengah 53463');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `favorit`
--
ALTER TABLE `favorit`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_fav` (`user_id`,`wisata_id`),
  ADD KEY `fk_favorit_wisata` (`wisata_id`);

--
-- Indexes for table `komentar`
--
ALTER TABLE `komentar`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_komentar_parent` (`parent_id`),
  ADD KEY `fk_komentar_wisata` (`wisata_id`),
  ADD KEY `fk_komentar_user` (`user_id`);

--
-- Indexes for table `laporan_komentar`
--
ALTER TABLE `laporan_komentar`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `komentar_id` (`komentar_id`,`pelapor_id`),
  ADD KEY `pelapor_id` (`pelapor_id`);

--
-- Indexes for table `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_like` (`user_id`,`wisata_id`),
  ADD KEY `fk_likes_wisata` (`wisata_id`);

--
-- Indexes for table `rating`
--
ALTER TABLE `rating`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_user_wisata` (`user_id`,`wisata_id`),
  ADD KEY `wisata_id` (`wisata_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `wisata`
--
ALTER TABLE `wisata`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `favorit`
--
ALTER TABLE `favorit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=105;

--
-- AUTO_INCREMENT for table `komentar`
--
ALTER TABLE `komentar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=288;

--
-- AUTO_INCREMENT for table `laporan_komentar`
--
ALTER TABLE `laporan_komentar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `likes`
--
ALTER TABLE `likes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=314;

--
-- AUTO_INCREMENT for table `rating`
--
ALTER TABLE `rating`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `wisata`
--
ALTER TABLE `wisata`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=155;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `favorit`
--
ALTER TABLE `favorit`
  ADD CONSTRAINT `fk_favorit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_favorit_wisata` FOREIGN KEY (`wisata_id`) REFERENCES `wisata` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `komentar`
--
ALTER TABLE `komentar`
  ADD CONSTRAINT `fk_komentar_parent` FOREIGN KEY (`parent_id`) REFERENCES `komentar` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_komentar_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_komentar_wisata` FOREIGN KEY (`wisata_id`) REFERENCES `wisata` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `laporan_komentar`
--
ALTER TABLE `laporan_komentar`
  ADD CONSTRAINT `laporan_komentar_ibfk_1` FOREIGN KEY (`komentar_id`) REFERENCES `komentar` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `laporan_komentar_ibfk_2` FOREIGN KEY (`pelapor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `fk_likes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_likes_wisata` FOREIGN KEY (`wisata_id`) REFERENCES `wisata` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `rating`
--
ALTER TABLE `rating`
  ADD CONSTRAINT `rating_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rating_ibfk_2` FOREIGN KEY (`wisata_id`) REFERENCES `wisata` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
