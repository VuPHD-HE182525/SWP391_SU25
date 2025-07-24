-- Fix packages table structure
-- Check current structure first
DESCRIBE packages;

-- Add missing columns if they don't exist
ALTER TABLE packages 
ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'active',
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Update existing packages to have status
UPDATE packages SET status = 'active' WHERE status IS NULL;

-- Verify the structure
DESCRIBE packages;

-- Show current packages
SELECT * FROM packages; 