USE music_db_system;

CREATE TABLE `UserActivity`(
    `ActivityID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `UserID (FK)` INT NOT NULL,
    `SongID (FK)` INT NOT NULL,
    `Timestamp` DATE NOT NULL,
    `Action` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `UserActivity` ADD PRIMARY KEY `useractivity_activityid_primary`(`ActivityID`);
CREATE TABLE `Songs`(
    `SongID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ArtistID (FK)` INT NOT NULL,
    `AlbumID (FK)` INT NOT NULL,
    `SongTitle` VARCHAR(255) NOT NULL,
    `Duration` INT NOT NULL
);
ALTER TABLE
    `Songs` ADD PRIMARY KEY `songs_songid_primary`(`SongID`);
CREATE TABLE `PaymentInfo`(
    `PaymentID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `UserID (FK)` INT NOT NULL,
    `CardNumber` BIGINT NOT NULL,
    `ExpiryDate` DATE NOT NULL,
    `BillingAddress` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `PaymentInfo` ADD PRIMARY KEY `paymentinfo_paymentid_primary`(`PaymentID`);
CREATE TABLE `Users`(
    `UserID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `FirstName` VARCHAR(255) NOT NULL,
    `LastName` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `SubscriptionType` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `Users` ADD PRIMARY KEY `users_userid_primary`(`UserID`);
CREATE TABLE `Artists`(
    `ArtistID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ArtistName` VARCHAR(255) NOT NULL,
    `Genre` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `Artists` ADD PRIMARY KEY `artists_artistid_primary`(`ArtistID`);
CREATE TABLE `Albums`(
    `AlbumID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ArtistID (FK)` INT NOT NULL,
    `AlbumName` VARCHAR(255) NOT NULL,
    `ReleaseDate` DATE NOT NULL
);
ALTER TABLE
    `Albums` ADD PRIMARY KEY `albums_albumid_primary`(`AlbumID`);
CREATE TABLE `Playlists`(
    `PlaylistID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `UserID (FK)` INT NOT NULL,
    `PlaylistName` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `Playlists` ADD PRIMARY KEY `playlists_playlistid_primary`(`PlaylistID`);
CREATE TABLE `PlaylistSongs`(
    `PlaylistSongID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `PlaylistID (FK)` INT NOT NULL,
    `SongID` INT NOT NULL
);
ALTER TABLE
    `PlaylistSongs` ADD PRIMARY KEY `playlistsongs_playlistsongid_primary`(`PlaylistSongID`);
ALTER TABLE
    `PlaylistSongs` ADD CONSTRAINT `playlistsongs_songid_foreign` FOREIGN KEY(`SongID`) REFERENCES `Songs`(`SongID`);
ALTER TABLE
    `Songs` ADD CONSTRAINT `songs_artistid (fk)_foreign` FOREIGN KEY(`ArtistID (FK)`) REFERENCES `Artists`(`ArtistID`);
ALTER TABLE
    `UserActivity` ADD CONSTRAINT `useractivity_songid (fk)_foreign` FOREIGN KEY(`SongID (FK)`) REFERENCES `Songs`(`SongID`);
ALTER TABLE
    `PlaylistSongs` ADD CONSTRAINT `playlistsongs_playlistid (fk)_foreign` FOREIGN KEY(`PlaylistID (FK)`) REFERENCES `Playlists`(`PlaylistID`);
ALTER TABLE
    `Albums` ADD CONSTRAINT `albums_artistid (fk)_foreign` FOREIGN KEY(`ArtistID (FK)`) REFERENCES `Artists`(`ArtistID`);
ALTER TABLE
    `UserActivity` ADD CONSTRAINT `useractivity_userid (fk)_foreign` FOREIGN KEY(`UserID (FK)`) REFERENCES `Users`(`UserID`);
ALTER TABLE
    `Songs` ADD CONSTRAINT `songs_albumid (fk)_foreign` FOREIGN KEY(`AlbumID (FK)`) REFERENCES `Albums`(`AlbumID`);
ALTER TABLE
    `Playlists` ADD CONSTRAINT `playlists_userid (fk)_foreign` FOREIGN KEY(`UserID (FK)`) REFERENCES `Users`(`UserID`);
ALTER TABLE
    `PaymentInfo` ADD CONSTRAINT `paymentinfo_userid (fk)_foreign` FOREIGN KEY(`UserID (FK)`) REFERENCES `Users`(`UserID`);