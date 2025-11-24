const fetch = require('node-fetch');
const sharp = require('sharp');

exports.handler = async (event, context) => {
  // Only allow POST requests
  if (event.httpMethod !== 'POST') {
    return {
      statusCode: 405,
      body: JSON.stringify({ error: 'Method not allowed' })
    };
  }

  try {
    const { image, type } = JSON.parse(event.body);
    
    if (!image) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'No image provided' })
      };
    }

    // Extract base64 data
    const base64Data = image.replace(/^data:image\/\w+;base64,/, '');
    const buffer = Buffer.from(base64Data, 'base64');

    // Compress image based on type
    let compressedBuffer;
    if (type === 'character') {
      // Character images: 150x150, higher quality
      compressedBuffer = await sharp(buffer)
        .resize(150, 150, { fit: 'cover' })
        .jpeg({ quality: 80 })
        .toBuffer();
    } else {
      // Story images: max 800px width, standard quality
      compressedBuffer = await sharp(buffer)
        .resize(800, null, { fit: 'inside', withoutEnlargement: true })
        .jpeg({ quality: 70 })
        .toBuffer();
    }

    // Convert back to base64
    const compressedBase64 = `data:image/jpeg;base64,${compressedBuffer.toString('base64')}`;

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
      },
      body: JSON.stringify({
        success: true,
        imageUrl: compressedBase64,
        originalSize: buffer.length,
        compressedSize: compressedBuffer.length,
        compressionRatio: ((1 - compressedBuffer.length / buffer.length) * 100).toFixed(2)
      })
    };
  } catch (error) {
    console.error('Image processing error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ 
        error: 'Image processing failed',
        details: error.message 
      })
    };
  }
};
