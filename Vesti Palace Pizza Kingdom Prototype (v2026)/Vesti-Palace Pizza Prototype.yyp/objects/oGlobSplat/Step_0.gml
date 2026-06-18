vy += gravity;
x += vx;
y += vy;
life--;
if life <= 0 instance_destroy();