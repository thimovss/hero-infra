import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Hero Infra Web UI",
  description: "A Simple web interface to create AWS native infrastructure",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
