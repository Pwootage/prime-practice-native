#![no_std]
#![allow(dead_code)]

extern crate alloc;

#[macro_use]
pub mod memory_object;
pub use memory_object::*;

#[allow(non_snake_case)]
pub mod mp1 {
    mod entities;
    mod game_objects;
    pub use game_objects::*;
    mod math;
}