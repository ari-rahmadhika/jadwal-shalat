-- Jadwal shalat
-- by: Ari Rahmadhika

-- SILAHKAN INSTALL DULU KERPELUANNYA SEBELUM MENJALANKAN SCRIPT
-- pkg install lua luarocks clang
-- luarocks install luasec
-- luarocks install dkjson

local https = require("ssl.https")
local json = require("dkjson")

local kota
local jadwal

function sendRequest(url)
    local dat = https.request(url)
    local tab = json.decode(dat)
    
    return tab
end

function getKodeKota(nama_kota)
    local url = "https://api.banghasan.com/sholat/format/json/kota/nama/" .. nama_kota
    
    return sendRequest(url)
end

function getJadwalShalat(nama_kota)
    local kode = getKodeKota(nama_kota)
    if kode.kota[1] ~= nil then
        local url = "https://api.banghasan.com/sholat/format/json/jadwal/kota/" .. kode.kota[1].id .. "/tanggal/" .. os.date("%Y-%m-%d")
        return sendRequest(url)
    else
        return false
    end
end

print("\nKetikkan nama kota:")
kota = io.read()

print("Sedang proses..")

jadwal = getJadwalShalat(kota)

if jadwal and jadwal.status == "ok" then
    print("\nJadwal shalat untuk wilayah " .. string.gsub(" " .. kota, "%W%l", string.upper):sub(2) .. "\n\n" ..
          "Maghrib:   " .. jadwal.jadwal.data.maghrib .. "\n" ..
          "'Isya:   " .. jadwal.jadwal.data.isya .. "\n" ..
          "Shubuh:   " .. jadwal.jadwal.data.subuh .. "\n" ..
          "Dzhuhur:   " .. jadwal.jadwal.data.dzuhur .. "\n" ..
          "'Ashar:   " .. jadwal.jadwal.data.ashar .. "\n")
else
    print("Jadwal tidak ditemukan. Masukkan kembali nama kota dengan benar!")
end
