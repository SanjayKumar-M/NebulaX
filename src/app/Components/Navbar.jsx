"use client"
import React from 'react'

const Navbar = () => {
  return (
    <div className='flex items-center justify-between p-5 mx-6'>
        <h1 className='font-bold text-5xl'>NebulaX</h1>
        <button className='border border-black bg-black p-3 text-white rounded-2xl font-bold '>Connect Wallet</button>
    </div>
  )
}

export default Navbar