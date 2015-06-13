database -open -default -shm waves.shm
probe -create tb_top -depth all -all -database waves.shm
run
exit

