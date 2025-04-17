// index.js
const express = require('express');
const app = express();

// Enable "trust proxy" so that req.ip reflects the originating client's IP address
app.set('trust proxy', true);

const PORT = process.env.PORT || 3000;

// Function to get the real client IP
const getClientIp = (req) => {
  // Check X-Forwarded-For header first (AWS ELB adds this)
  const forwardedFor = req.headers['x-forwarded-for'];
  if (forwardedFor) {
    // Get the first IP in the list (original client IP)
    const ips = forwardedFor.split(',').map(ip => ip.trim());
    return ips[0];
  }

  // Check other common headers
  const realIp = req.headers['x-real-ip'] || 
                 req.headers['x-client-ip'] ||
                 req.headers['cf-connecting-ip'] ||
                 req.headers['true-client-ip'];
  
  if (realIp) {
    return realIp;
  }

  // Fallback to req.ip
  let ip = req.ip;
  if (ip.startsWith('::ffff:')) {
    ip = ip.substring(7);
  }
  return ip;
};

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.get('/', (req, res) => {
  try {
    // Get the current date and time in ISO format
    const timestamp = new Date().toISOString();
    
    // Get the client's real IP address
    const ip = getClientIp(req);
    
    // Log headers for debugging
    console.log('Request headers:', req.headers);
    console.log('Original IP:', req.ip);
    console.log('Detected client IP:', ip);
    
    res.json({ timestamp, ip });
  } catch (error) {
    console.error('Error occurred while processing request:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Error Handling middleware
app.use((err, req, res, next) => {
  console.error('Unhandled error:', err);
  res.status(500).json({ error: 'Internal Server Error' });
});

app.listen(PORT, (err) => {
  if (err) {
    console.error('Error occurred while starting the Server:', err);
    process.exit(1);
  }
  console.log(`SimpleTimeService is running on Port ${PORT}`);
});
