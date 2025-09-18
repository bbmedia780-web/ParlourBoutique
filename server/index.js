import express from 'express';
import cors from 'cors';
import nodemailer from 'nodemailer';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// Configure SMTP transporter from env
const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: Number(process.env.SMTP_PORT || 587),
  secure: process.env.SMTP_SECURE === 'true',
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS,
  },
});

app.post('/api/delete-account', async (req, res) => {
  try {
    const { fullName, phone, email, country, reason } = req.body || {};
    if (!fullName || !phone || !email || !country) {
      return res.status(400).json({ ok: false, message: 'Missing required fields' });
    }

    // Mail to support/inbox
    const supportMail = {
      from: process.env.MAIL_FROM || process.env.SMTP_USER,
      to: process.env.SUPPORT_TO || 'info@brightbrewmedia@gmail.com',
      subject: `Delete Account Request - ${fullName} (${phone})`,
      text: `A user requested account deletion.\n\nName: ${fullName}\nPhone: ${phone}\nEmail: ${email}\nCountry: ${country}\nReason: ${reason || '-'}\n\nPlease verify via OTP and process within 30 days.`,
    };

    // Acknowledgment to user
    const userMail = {
      from: process.env.MAIL_FROM || process.env.SMTP_USER,
      to: email,
      subject: 'We received your account deletion request - Vamika',
      text: `Hello ${fullName},\n\nWe have received your account deletion request for Vamika - Salon, Style & More.\n\nNext steps:\n1) We will verify your identity via OTP on your registered phone/email.\n2) Upon successful verification, deletion will be completed within 30 days.\n\nIf you did not request this, contact us immediately at info@brightbrewmedia@gmail.com or +91 8460093493.\n\nRegards,\nBrightbrew Media & Solutions Pvt Ltd`,
    };

    await transporter.sendMail(supportMail);
    await transporter.sendMail(userMail);

    return res.json({ ok: true, message: 'Request submitted. Email confirmations sent.' });
  } catch (err) {
    console.error('Email send failed', err);
    return res.status(500).json({ ok: false, message: 'Failed to submit request' });
  }
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => console.log(`Delete account server running on :${PORT}`));


