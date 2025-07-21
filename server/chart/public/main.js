WIDTH = 800
HEIGHT = 800
BUFFER = 100
POINT_SIZE = 5
IMAGE_SIZE = 64


class Client {
    constructor(ctx) {
        this.ctx = ctx;
        this.points = [];
        this.hover = null;
        this.imagecache = {};
        document.getElementById("chart").addEventListener("mousemove", this.event_mouse_move.bind(this));
        window.requestAnimationFrame(this.draw.bind(this));
    }

    draw(timestamp) {
        window.requestAnimationFrame(this.draw.bind(this));

        // Background
        this.ctx.fillStyle = "#F6F6F6";
        this.ctx.fillRect(0, 0, WIDTH, HEIGHT);

        // Box
        this.ctx.beginPath()
        this.ctx.strokeStyle = "#000000";
        this.ctx.moveTo(BUFFER, BUFFER)
        this.ctx.lineTo(BUFFER, HEIGHT-BUFFER)
        this.ctx.lineTo(WIDTH-BUFFER, HEIGHT-BUFFER)
        this.ctx.lineTo(WIDTH-BUFFER, BUFFER)
        this.ctx.lineTo(BUFFER, BUFFER)
        this.ctx.stroke()

        // Ticks
        for (let x = BUFFER + (WIDTH - BUFFER * 2) / 10; x < WIDTH - BUFFER; x+=(WIDTH - BUFFER * 2) / 10) {
            this.ctx.beginPath()
            this.ctx.strokeStyle = "#000000";
            this.ctx.moveTo(x, HEIGHT - BUFFER)
            this.ctx.lineTo(x, HEIGHT - BUFFER - 10)
            this.ctx.stroke()

            this.ctx.beginPath()
            this.ctx.strokeStyle = "#F0F0F0";
            this.ctx.moveTo(x, HEIGHT - BUFFER - 10)
            this.ctx.lineTo(x, BUFFER)
            this.ctx.stroke()
        }

        for (let y = BUFFER + (HEIGHT - BUFFER * 2) / 10; y < HEIGHT - BUFFER; y+=(HEIGHT - BUFFER * 2) / 10) {
            this.ctx.beginPath()
            this.ctx.strokeStyle = "#000000";
            this.ctx.moveTo(BUFFER, y)
            this.ctx.lineTo(WIDTH - (WIDTH - BUFFER - 10), y)
            this.ctx.stroke()

            this.ctx.beginPath()
            this.ctx.strokeStyle = "#F0F0F0";
            this.ctx.moveTo(BUFFER + 10, y)
            this.ctx.lineTo(WIDTH - (BUFFER), y)
            this.ctx.stroke()
        }

        // Points
        this.points.forEach((p) => {
            // Shadow
            this.ctx.beginPath();
            this.ctx.strokeStyle = "#000000";
            this.ctx.fillStyle = `rgb(${Math.floor(200 * p.presence / 2) + 50}, 0, ${Math.floor(200 * (p.effectiveness / 2)) + 50})`;
            this.ctx.ellipse(
                Math.floor(1 + BUFFER + ((WIDTH - BUFFER * 2) * p.presence)),
                Math.floor(1 + BUFFER + ((HEIGHT - BUFFER * 2) * (1 - p.effectiveness))),
                POINT_SIZE, POINT_SIZE, 0, 0, Math.PI * 2
            );
            this.ctx.fill();
            this.ctx.stroke();

            // Point
            this.ctx.beginPath()
            this.ctx.strokeStyle = "#000000";
            this.ctx.fillStyle = `rgb(${Math.floor(200 * p.presence) + 50}, 0, ${Math.floor(200 * (p.effectiveness)) + 50})`;
            this.ctx.ellipse(
                Math.floor(BUFFER + ((WIDTH - BUFFER * 2) * p.presence)),
                Math.floor(BUFFER + ((HEIGHT - BUFFER * 2) * (1 - p.effectiveness))),
                POINT_SIZE, POINT_SIZE, 0, 0, Math.PI * 2
            );
            this.ctx.fill();
            this.ctx.stroke();
        })

        // Axis labels
        this.ctx.font = "17px serif";
        this.ctx.fillStyle = `#444444`;
        this.ctx.fillText("Presence", WIDTH / 2 - 25, HEIGHT - BUFFER / 2);
        this.ctx.fillText("Effectiveness", 2, HEIGHT / 2);
        
        if (!this.hover) {
            return;
        }

        let hoverX = Math.floor(BUFFER + ((WIDTH - BUFFER * 2) * this.hover.presence));
        let hoverY = Math.floor(BUFFER + ((HEIGHT - BUFFER * 2) * (1 - this.hover.effectiveness)));

        // Hover color
        this.ctx.beginPath();
        this.ctx.strokeStyle = "#000000";
        this.ctx.fillStyle = `#00FF00`;
        this.ctx.ellipse(hoverX, hoverY, POINT_SIZE, POINT_SIZE, 0, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.stroke();

        // Hover popup image background
        this.ctx.beginPath();
        this.ctx.strokeStyle = "#000000";
        this.ctx.fillStyle = `#444444`;
        this.ctx.moveTo(hoverX, hoverY - POINT_SIZE);
        this.ctx.lineTo(hoverX + 4, hoverY - POINT_SIZE - 4);
        this.ctx.lineTo(hoverX + ((IMAGE_SIZE + 2) / 2), hoverY - POINT_SIZE - 4);
        this.ctx.lineTo(hoverX + ((IMAGE_SIZE + 2) / 2), hoverY - POINT_SIZE - 4 - (IMAGE_SIZE + 2));
        this.ctx.lineTo(hoverX - ((IMAGE_SIZE + 2) / 2), hoverY - POINT_SIZE - 4 - (IMAGE_SIZE + 2));
        this.ctx.lineTo(hoverX - ((IMAGE_SIZE + 2) / 2), hoverY - POINT_SIZE - 4);
        this.ctx.lineTo(hoverX - 4, hoverY - POINT_SIZE - 4);
        this.ctx.lineTo(hoverX, hoverY - POINT_SIZE);
        this.ctx.fill();
        this.ctx.stroke();

        // Fallback background text
        // Remove this when images work correctly :)
        this.ctx.font = "7px serif";
        this.ctx.fillStyle = `#FF00FF`;
        this.ctx.fillText(this.hover.name, 4 + hoverX - ((IMAGE_SIZE) / 2), 10 + hoverY - POINT_SIZE - (IMAGE_SIZE + 1));

        // Hover popup image
        let img = this.imagecache[this.hover.url]
        if (img == undefined) {
            img = new Image();
            img.src = this.hover.url;
            this.imagecache[this.hover.url] = img;
        }

        if (img.complete) {
            this.ctx.drawImage(img, hoverX - ((IMAGE_SIZE) / 2), hoverY - POINT_SIZE - 4 - (IMAGE_SIZE + 1), IMAGE_SIZE, IMAGE_SIZE);
        }
    }

    event_mouse_move(event) {
        let best = null
        let bestDist = Infinity
        this.points.forEach((p) => {
            let x1 = event.offsetX
            let y1 = event.offsetY
            let x2 = Math.floor(BUFFER + ((WIDTH - BUFFER * 2) * p.presence))
            let y2 = Math.floor(BUFFER + ((HEIGHT - BUFFER * 2) * (1 - p.effectiveness)))
            let dist = Math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)
            if (dist <= POINT_SIZE * 3 && dist < bestDist) {
                best = p
                bestDist = dist
            }
        })

        this.hover = best
    }
}

let client = null;

window.onload = async () => {
    ctx = document.getElementById("chart").getContext("2d");

    cli = new Client(ctx);

    response = await fetch("/all")
    cli.points = await response.json()

    client = cli;
}