// server.js - Entry Point
require('dotenv').config();

const express        = require('express');
const session        = require('express-session');
const flash          = require('connect-flash');
const methodOverride = require('method-override');
const path           = require('path');
const routes         = require('./routes');
const { setLocals }  = require('./middleware/auth');

const app  = express();
const PORT = process.env.PORT || 3000;

// ── VIEW ENGINE ──────────────────────────────────────────────
// Dùng EJS (cần cài: npm install ejs)
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// ── MIDDLEWARE ────────────────────────────────────────────────
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(express.json({ limit: '10mb' }));
app.use(methodOverride('_method'));
app.use(express.static(path.join(__dirname, 'public')));

// Session
app.use(session({
    secret: process.env.SESSION_SECRET || 'veso_secret',
    resave: false,
    saveUninitialized: false,
    cookie: {
        secure: false,          // true nếu dùng HTTPS
        maxAge: 8 * 60 * 60 * 1000 // 8 giờ
    }
}));

app.use(flash());
app.use(setLocals);  // gắn user + flash vào res.locals

// ── ROUTES ────────────────────────────────────────────────────
app.use('/', routes);

// ── 404 ───────────────────────────────────────────────────────
app.use((req, res) => {
    res.status(404).render('pages/404', { title: '404 - Không Tìm Thấy' });
});

// ── ERROR HANDLER ─────────────────────────────────────────────
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).render('pages/error', { title: 'Lỗi Hệ Thống', message: err.message });
});

// ── START ─────────────────────────────────────────────────────
app.listen(PORT, () => {
    console.log('');
    console.log('╔══════════════════════════════════════════╗');
    console.log('║     WEBSITE QUẢN LÝ BÁN VÉ SỐ           ║');
    console.log('╠══════════════════════════════════════════╣');
    console.log(`║  Server đang chạy: http://localhost:${PORT}  ║`);
    console.log('╚══════════════════════════════════════════╝');
    console.log('');
});
