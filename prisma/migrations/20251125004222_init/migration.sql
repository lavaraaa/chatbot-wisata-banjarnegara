-- CreateTable
CREATE TABLE `favorit` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `wisata_id` INTEGER NOT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `fk_favorit_wisata`(`wisata_id`),
    UNIQUE INDEX `unique_fav`(`user_id`, `wisata_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `komentar` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `wisata_id` INTEGER NOT NULL,
    `isi` TEXT NOT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `parent_id` INTEGER NULL,

    INDEX `fk_komentar_parent`(`parent_id`),
    INDEX `fk_komentar_user`(`user_id`),
    INDEX `fk_komentar_wisata`(`wisata_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `laporan_komentar` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `komentar_id` INTEGER NOT NULL,
    `pelapor_id` INTEGER NOT NULL,
    `alasan` TEXT NULL,
    `tanggal_lapor` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `pelapor_id`(`pelapor_id`),
    UNIQUE INDEX `komentar_id`(`komentar_id`, `pelapor_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `likes` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `wisata_id` INTEGER NOT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `fk_likes_wisata`(`wisata_id`),
    UNIQUE INDEX `unique_like`(`user_id`, `wisata_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `rating` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `wisata_id` INTEGER NOT NULL,
    `rating` TINYINT NOT NULL,
    `review` TEXT NULL,
    `images` LONGTEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `wisata_id`(`wisata_id`),
    UNIQUE INDEX `uk_user_wisata`(`user_id`, `wisata_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `users` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(255) NULL,
    `email` VARCHAR(100) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `role` ENUM('user', 'admin') NULL DEFAULT 'user',
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `photoURL` VARCHAR(255) NULL,

    UNIQUE INDEX `email`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `wisata` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `judul` VARCHAR(255) NOT NULL,
    `gambar` VARCHAR(255) NULL,
    `deskripsi` TEXT NULL,
    `jam_buka` VARCHAR(10) NULL,
    `jam_tutup` VARCHAR(10) NULL,
    `no_telepon` VARCHAR(20) NULL,
    `harga_tiket` DECIMAL(10, 2) NULL,
    `link_gmaps` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `kategori` VARCHAR(255) NULL,
    `fasilitas` TEXT NULL,
    `galeri` TEXT NULL,
    `alamat` VARCHAR(255) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `favorit` ADD CONSTRAINT `fk_favorit_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `favorit` ADD CONSTRAINT `fk_favorit_wisata` FOREIGN KEY (`wisata_id`) REFERENCES `wisata`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `komentar` ADD CONSTRAINT `fk_komentar_parent` FOREIGN KEY (`parent_id`) REFERENCES `komentar`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `komentar` ADD CONSTRAINT `fk_komentar_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `komentar` ADD CONSTRAINT `fk_komentar_wisata` FOREIGN KEY (`wisata_id`) REFERENCES `wisata`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `laporan_komentar` ADD CONSTRAINT `laporan_komentar_ibfk_1` FOREIGN KEY (`komentar_id`) REFERENCES `komentar`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `laporan_komentar` ADD CONSTRAINT `laporan_komentar_ibfk_2` FOREIGN KEY (`pelapor_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `likes` ADD CONSTRAINT `fk_likes_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `likes` ADD CONSTRAINT `fk_likes_wisata` FOREIGN KEY (`wisata_id`) REFERENCES `wisata`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `rating` ADD CONSTRAINT `rating_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `rating` ADD CONSTRAINT `rating_ibfk_2` FOREIGN KEY (`wisata_id`) REFERENCES `wisata`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
