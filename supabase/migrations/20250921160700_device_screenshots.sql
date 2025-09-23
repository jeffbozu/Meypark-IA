-- MEYPARK IA - Device Screenshots Table
-- Tabla para almacenar capturas de pantalla de dispositivos

-- Device Screenshots
CREATE TABLE device_screenshots (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  filename TEXT NOT NULL,
  url TEXT NOT NULL,
  format TEXT NOT NULL DEFAULT 'png',
  size_bytes INTEGER,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE device_screenshots ENABLE ROW LEVEL SECURITY;

-- RLS Policies for device_screenshots
CREATE POLICY "Users can view screenshots for their company devices" ON device_screenshots
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = device_screenshots.company_id
    )
  );

CREATE POLICY "Devices can insert their own screenshots" ON device_screenshots
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'device' AND company_id = device_screenshots.company_id
    )
  );

CREATE POLICY "Admins can manage all screenshots" ON device_screenshots
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- Index for performance
CREATE INDEX idx_device_screenshots_device_created ON device_screenshots (device_id, created_at DESC);
CREATE INDEX idx_device_screenshots_company_created ON device_screenshots (company_id, created_at DESC);

-- Add to realtime publication
ALTER PUBLICATION supabase_realtime ADD TABLE device_screenshots;
ALTER TABLE device_screenshots REPLICA IDENTITY FULL;
