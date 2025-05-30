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
    local url = "https://api.myquran.com/v2/sholat/kota/cari/" .. nama_kota
    
    return sendRequest(url)
end

function getJadwalShalat(nama_kota)
    local kode = getKodeKota(nama_kota)
    if kode.status ~= false then
        local url = "https://api.myquran.com/v2/sholat/jadwal/" .. kode.data[1].id .. "/" .. os.date("%Y-%m-%d")
        return sendRequest(url)
    else
        return false
    end
end

print("\nKetikkan nama kota:")
kota = io.read()

print("Sedang proses..")

jadwal = getJadwalShalat(kota)

if jadwal and jadwal.status == true then
    print("\nJadwal shalat untuk wilayah " .. string.gsub(" " .. kota, "%W%l", string.upper):sub(2) .. "\n\n" ..
          "Maghrib:   " .. jadwal.data.jadwal.maghrib .. "\n" ..
          "'Isya:   " .. jadwal.data.jadwal.isya .. "\n" ..
          "Shubuh:   " .. jadwal.data.jadwal.subuh .. "\n" ..
          "Dzhuhur:   " .. jadwal.data.jadwal.dzuhur .. "\n" ..
          "'Ashar:   " .. jadwal.data.jadwal.ashar .. "\n")
else
    print("Jadwal tidak ditemukan. Masukkan kembali nama kota dengan benar!")
end
