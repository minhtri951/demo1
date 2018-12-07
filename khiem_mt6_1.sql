-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Máy chủ: localhost
-- Thời gian đã tạo: Th9 20, 2018 lúc 04:11 AM
-- Phiên bản máy phục vụ: 10.1.35-MariaDB
-- Phiên bản PHP: 7.1.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `khiem_mt6_1`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `in_commission_millionaire`
--

CREATE TABLE `in_commission_millionaire` (
  `id` int(11) NOT NULL,
  `senderid` int(11) NOT NULL COMMENT 'Sender',
  `receiverid` int(11) NOT NULL COMMENT 'Receiver',
  `date_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `volum_week` double NOT NULL COMMENT 'Volume sender trade last week',
  `type` varchar(50) NOT NULL COMMENT 'F1, F2, F3,..F10',
  `amount` double NOT NULL COMMENT 'Commission amount received',
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `in_commission_trade`
--

CREATE TABLE `in_commission_trade` (
  `id` int(11) NOT NULL,
  `senderid` int(11) NOT NULL COMMENT 'Sender',
  `receiverid` int(11) NOT NULL COMMENT 'Receiver',
  `date_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `volum24h` double NOT NULL COMMENT 'Volume sender trade last 24h',
  `type` varchar(50) NOT NULL COMMENT 'F1, F2, F3',
  `amount` double NOT NULL COMMENT 'Commission amount received',
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_candle`
--

CREATE TABLE `tb_candle` (
  `id` int(11) NOT NULL,
  `marketname` varchar(50) NOT NULL,
  `base_vol` double NOT NULL,
  `close` double NOT NULL,
  `high` double NOT NULL,
  `time` bigint(20) NOT NULL,
  `low` double NOT NULL,
  `open` double NOT NULL,
  `quote_vol` double NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_commission_deposit`
--

CREATE TABLE `tb_commission_deposit` (
  `id` int(11) NOT NULL,
  `depositid` int(11) NOT NULL COMMENT 'id in table deposit',
  `receiverid` int(11) NOT NULL,
  `amount` double NOT NULL,
  `date_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` varchar(50) NOT NULL COMMENT 'F1, F2, F3',
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_config`
--

CREATE TABLE `tb_config` (
  `id` int(11) NOT NULL,
  `param` varchar(50) NOT NULL,
  `value` double NOT NULL,
  `note` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_deposit`
--

CREATE TABLE `tb_deposit` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `date_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Deposite date',
  `code` varchar(255) NOT NULL COMMENT 'ETH/BTC',
  `quantity` double NOT NULL,
  `USD` double NOT NULL,
  `txhash` varchar(255) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_order`
--

CREATE TABLE `tb_order` (
  `id` int(11) NOT NULL,
  `userid` varchar(255) NOT NULL,
  `opentime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `quantity` double NOT NULL,
  `marketname` varchar(50) NOT NULL,
  `option` varchar(20) NOT NULL COMMENT 'BUY SELL',
  `wallet` varchar(20) NOT NULL COMMENT 'LIVE BASE DEMO',
  `result` varchar(20) DEFAULT NULL COMMENT 'WIN LOSE',
  `round` bigint(11) NOT NULL,
  `profit` double NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_result`
--

CREATE TABLE `tb_result` (
  `id` int(11) NOT NULL,
  `marketname` varchar(50) NOT NULL,
  `result` varchar(50) NOT NULL COMMENT 'PUT/CALL'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_session`
--

CREATE TABLE `tb_session` (
  `session_id` varchar(255) NOT NULL,
  `expires` int(11) UNSIGNED NOT NULL,
  `data` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_token`
--

CREATE TABLE `tb_token` (
  `id` int(11) NOT NULL,
  `userid` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_trade_fee`
--

CREATE TABLE `tb_trade_fee` (
  `id` int(11) NOT NULL,
  `hour` int(11) NOT NULL,
  `value` int(11) NOT NULL COMMENT '%',
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_transfer`
--

CREATE TABLE `tb_transfer` (
  `id` int(11) NOT NULL,
  `senderid` int(11) NOT NULL,
  `receiverid` int(11) NOT NULL,
  `amount` double NOT NULL,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_user`
--

CREATE TABLE `tb_user` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `displayname` varchar(255) NOT NULL,
  `livebalance` double NOT NULL DEFAULT '0',
  `demobalance` double NOT NULL DEFAULT '1000',
  `playmode` varchar(255) NOT NULL DEFAULT 'DEMO',
  `win` int(11) NOT NULL DEFAULT '0',
  `lose` int(11) NOT NULL DEFAULT '0',
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'VERIFY' COMMENT 'VERIFY/ACTIVE/INACTIVE',
  `activation_code` varchar(10) NOT NULL COMMENT 'verify email by code',
  `ref` int(11) DEFAULT '1',
  `parent` varchar(255) DEFAULT NULL COMMENT '{F1,F2,F3}',
  `mfa` tinyint(1) NOT NULL DEFAULT '0',
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_user_2fa`
--

CREATE TABLE `tb_user_2fa` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `mfacode` varchar(255) NOT NULL,
  `otpauth_url` varchar(255) NOT NULL,
  `lasttry` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_user_admin`
--

CREATE TABLE `tb_user_admin` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_wallet_code`
--

CREATE TABLE `tb_wallet_code` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `wallet` varchar(255) NOT NULL,
  `code` varchar(10) NOT NULL,
  `label` varchar(255) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_withdraw`
--

CREATE TABLE `tb_withdraw` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `date_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `code` varchar(255) NOT NULL COMMENT 'ETH/BTC',
  `amount` double NOT NULL COMMENT 'TOTAL USD WITHDRWAL',
  `quantity` double NOT NULL COMMENT 'amount coin',
  `wallet_address` varchar(255) NOT NULL,
  `rate` double NOT NULL COMMENT 'PRICE BTC ETH AS USD',
  `fee` double NOT NULL COMMENT 'fee withdrawal',
  `real_quantity` double NOT NULL COMMENT 'real amount coin',
  `status` varchar(50) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING-CANCEL-COMPLETED',
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `in_commission_millionaire`
--
ALTER TABLE `in_commission_millionaire`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `in_commission_trade`
--
ALTER TABLE `in_commission_trade`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tb_candle`
--
ALTER TABLE `tb_candle`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `time` (`time`,`marketname`);

--
-- Chỉ mục cho bảng `tb_commission_deposit`
--
ALTER TABLE `tb_commission_deposit`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tb_config`
--
ALTER TABLE `tb_config`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tb_deposit`
--
ALTER TABLE `tb_deposit`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `txhash` (`txhash`);

--
-- Chỉ mục cho bảng `tb_order`
--
ALTER TABLE `tb_order`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tb_result`
--
ALTER TABLE `tb_result`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tb_session`
--
ALTER TABLE `tb_session`
  ADD PRIMARY KEY (`session_id`);

--
-- Chỉ mục cho bảng `tb_token`
--
ALTER TABLE `tb_token`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tb_trade_fee`
--
ALTER TABLE `tb_trade_fee`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tb_transfer`
--
ALTER TABLE `tb_transfer`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tb_user`
--
ALTER TABLE `tb_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Chỉ mục cho bảng `tb_user_2fa`
--
ALTER TABLE `tb_user_2fa`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tb_user_admin`
--
ALTER TABLE `tb_user_admin`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tb_wallet_code`
--
ALTER TABLE `tb_wallet_code`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tb_withdraw`
--
ALTER TABLE `tb_withdraw`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `in_commission_millionaire`
--
ALTER TABLE `in_commission_millionaire`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `in_commission_trade`
--
ALTER TABLE `in_commission_trade`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tb_candle`
--
ALTER TABLE `tb_candle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tb_commission_deposit`
--
ALTER TABLE `tb_commission_deposit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tb_config`
--
ALTER TABLE `tb_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tb_deposit`
--
ALTER TABLE `tb_deposit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tb_order`
--
ALTER TABLE `tb_order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tb_result`
--
ALTER TABLE `tb_result`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tb_token`
--
ALTER TABLE `tb_token`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tb_trade_fee`
--
ALTER TABLE `tb_trade_fee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tb_transfer`
--
ALTER TABLE `tb_transfer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tb_user`
--
ALTER TABLE `tb_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tb_user_2fa`
--
ALTER TABLE `tb_user_2fa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tb_user_admin`
--
ALTER TABLE `tb_user_admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tb_wallet_code`
--
ALTER TABLE `tb_wallet_code`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tb_withdraw`
--
ALTER TABLE `tb_withdraw`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
