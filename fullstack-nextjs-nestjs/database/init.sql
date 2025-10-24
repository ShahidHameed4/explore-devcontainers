-- Database initialization script for FullStack DevContainer Demo
-- This script runs when the PostgreSQL container starts for the first time

-- Create the database if it doesn't exist
-- (The database is already created by POSTGRES_DB environment variable)

-- Create a sample table for demonstration
CREATE TABLE IF NOT EXISTS sample_data (
    id SERIAL PRIMARY KEY,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert some sample data
INSERT INTO sample_data (message) VALUES 
    ('Welcome to FullStack DevContainer!'),
    ('PostgreSQL is running successfully'),
    ('Ready for development!')
ON CONFLICT DO NOTHING;

-- Create an index for better performance
CREATE INDEX IF NOT EXISTS idx_sample_data_created_at ON sample_data(created_at);

-- Display a success message
DO $$
BEGIN
    RAISE NOTICE 'Database initialization completed successfully!';
    RAISE NOTICE 'FullStack DevContainer Demo database is ready.';
END $$;
