import Navigation from "./components/Navigation"

export const metadata = {
  title: 'Next.js',
  description: 'Generated by Next.js',
}


 
export default function RootLayout({ children }) {
 return (
    <html lang="en">
      <head>
        <title>SHM</title>
      </head>
      <body>
      <Navigation />
        {children}
        </body>
    </html>
  )
}
