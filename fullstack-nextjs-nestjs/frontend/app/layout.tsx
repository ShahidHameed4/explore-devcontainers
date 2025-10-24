import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'FullStack DevContainer Demo',
  description: 'A full-stack application running in VS Code DevContainer',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
