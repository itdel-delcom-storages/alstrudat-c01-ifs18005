#!/bin/bash

# Hentikan script jika terjadi error (diubah menjadi tidak berhenti)
set +e

# Compile Java program dengan Maven
echo "🔨 Compiling Java program..."
if ! mvn clean package; then
  echo "❌ Build failed! Exiting..."
  exit 1
fi
echo "✅ Build successful!"

# Pastikan file weights.txt ada
if [ ! -f testcases/weights.txt ]; then
  echo "❌ Error: File testcases/weights.txt not found!"
  exit 1
fi

# Variabel untuk menyimpan nilai akhir
total_score=0
index=1

# Baca bobot dari file weights.txt
while read -r weight; do
  input_file="testcases/input$index.txt"
  expected_file="testcases/expected$index.txt"
  output_file="testcases/output$index.txt"
  actual_output_file="testcases/actual_output$index.txt"  # Tambahkan ini

  # Pastikan file test case tersedia
  if [ ! -f "$input_file" ] || [ ! -f "$expected_file" ]; then
    echo "⚠️ Warning: Test case $index files missing. Skipping..."
    index=$((index + 1))
    continue
  fi

  echo "🚀 Running test case $index (Weight: $weight%)..."

  # Jalankan program dengan input dari file dan simpan outputnya
  java -cp target/alstrudat-c01-ifs18005-1.0-SNAPSHOT.jar del.alstrudat.App < "$input_file" > "$output_file"

  # Simpan output aktual ke dalam folder 'testcases' (actual_output)
  cp "$output_file" "$actual_output_file"

  # Bandingkan output dengan expected output
  if diff -q "$output_file" "$expected_file" > /dev/null; then
    echo "✅ Test case $index passed! (+$weight%)"
    total_score=$((total_score + weight))
  else
    echo "❌ Test case $index failed!"
  fi

  index=$((index + 1))
done < testcases/weights.txt

echo "🎯 Final Score: $total_score%"

# Jika nilai akhir di atas 70%, dianggap lulus
if [ "$total_score" -ge 50 ]; then
  echo "✅ All tests passed! (Score: $total_score%)"
  exit 0
else
  echo "❌ Tests failed! (Score: $total_score%)"
  exit 1
fi
